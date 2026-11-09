//
//  UnitConverter.swift
//  The Ultimate Recipe Hub
//
//  US / Metric amounts (1.4). Recipes are stored in the units they were written in; only what is shown is
//  converted: servings scale first, then convert, then round the way a kitchen would. The recipe author's own
//  second amount ("200 g (7 oz)") wins over any formula.
//

import Foundation

/// The units amounts are shown in.
enum UnitSystem: String {
    case us, metric

    /// "metric" / "US", for the converted-amounts note.
    var name: String { self == .us ? "US" : "metric" }
}

/// The Units choice in Settings. Automatic follows the phone's region: the US gets US units, everywhere else,
/// the UK included, gets metric.
enum UnitsSetting: String, CaseIterable, Identifiable {
    case automatic, metric, us

    var id: String { rawValue }

    /// @AppStorage key, so views redraw when it changes.
    static let storageKey = "unitsSetting"

    static var current: UnitsSetting {
        UnitsSetting(rawValue: UserDefaults.standard.string(forKey: storageKey) ?? "") ?? .automatic
    }

    /// iOS reports US, metric and UK systems; the UK cooks in metric.
    static var regionSystem: UnitSystem {
        Locale.current.measurementSystem == .us ? .us : .metric
    }

    var system: UnitSystem {
        switch self {
        case .automatic: return UnitsSetting.regionSystem
        case .metric: return .metric
        case .us: return .us
        }
    }

    /// The units amounts are shown in right now.
    static var activeSystem: UnitSystem { current.system }
}

enum UnitConverter {

    // MARK: - Result

    /// One ingredient line's amount: "1½ cups", "120 g", "3 tbsp (40 g)", "1 can" with detail "425 g".
    struct Measure: Equatable {
        /// The amount and unit, shown before the name.
        let amount: String
        /// A second amount, shown after the name in brackets: "about 1 lb each", "8 cloves".
        let detail: String?
        /// Not in the recipe's own units: the recipe page then shows the converted-amounts note.
        let isConverted: Bool

        /// "1 can (425 g)", for places with one text, such as the grocery list.
        var combined: String { detail.map { "\(amount) (\($0))" } ?? amount }
    }

    // MARK: - Units

    enum Kind { case volume, weight, length }

    struct UnitInfo {
        /// nil for spoons: the same in both systems.
        let system: UnitSystem?
        let dimension: Kind
        /// ml, g or cm in one unit.
        let base: Double
        var isSpoon: Bool { system == nil }
    }

    /// Kitchen equivalents: 1 cup = 240 ml (16 tbsp of 15 ml), so cups, spoons and ml convert to round numbers.
    private static let units: [String: UnitInfo] = [
        "tsp": UnitInfo(system: nil, dimension: .volume, base: 5),
        "tbsp": UnitInfo(system: nil, dimension: .volume, base: 15),
        "cup": UnitInfo(system: .us, dimension: .volume, base: 240),
        "fl oz": UnitInfo(system: .us, dimension: .volume, base: 29.5735),
        "pint": UnitInfo(system: .us, dimension: .volume, base: 473.176),
        "quart": UnitInfo(system: .us, dimension: .volume, base: 946.353),
        "gallon": UnitInfo(system: .us, dimension: .volume, base: 3785.41),
        "oz": UnitInfo(system: .us, dimension: .weight, base: 28.3495),
        "lb": UnitInfo(system: .us, dimension: .weight, base: 453.592),
        "ml": UnitInfo(system: .metric, dimension: .volume, base: 1),
        "l": UnitInfo(system: .metric, dimension: .volume, base: 1000),
        "g": UnitInfo(system: .metric, dimension: .weight, base: 1),
        "kg": UnitInfo(system: .metric, dimension: .weight, base: 1000),
        "inch": UnitInfo(system: .us, dimension: .length, base: 2.54),
        "inch piece": UnitInfo(system: .us, dimension: .length, base: 2.54),
        "cm": UnitInfo(system: .metric, dimension: .length, base: 1),
        "mm": UnitInfo(system: .metric, dimension: .length, base: 0.1)
    ]

    /// A stick of butter is a weight (113 g); a stick of celery is a count.
    private static let butterStick = UnitInfo(system: .us, dimension: .weight, base: 113)

    /// Units that count things: shown as they are, with a plural ("2 cans"), in both systems.
    private static let plurals: [String: String] = [
        "cup": "cups", "pint": "pints", "quart": "quarts", "gallon": "gallons",
        "clove": "cloves", "slice": "slices", "piece": "pieces", "sprig": "sprigs", "handful": "handfuls",
        "pinch": "pinches", "dash": "dashes", "can": "cans", "tin": "tins", "stick": "sticks", "head": "heads",
        "packet": "packets", "package": "packages", "jar": "jars", "sheet": "sheets", "strip": "strips",
        "ear": "ears", "stalk": "stalks", "leaf": "leaves", "drop": "drops", "bag": "bags", "box": "boxes",
        "bottle": "bottles", "fillet": "fillets", "link": "links", "bunch": "bunches",
        "small bunch": "small bunches", "pod": "pods", "breast": "breasts", "splash": "splashes"
    ]

    /// Older spellings, for recipes saved before the 1.4 units pass (and recipes added later).
    private static let aliases: [String: String] = [
        "cups": "cup", "c": "cup", "tablespoon": "tbsp", "tablespoons": "tbsp", "tbs": "tbsp", "tbl": "tbsp",
        "teaspoon": "tsp", "teaspoons": "tsp", "ounce": "oz", "ounces": "oz", "fluid ounce": "fl oz",
        "fluid ounces": "fl oz", "pound": "lb", "pounds": "lb", "lbs": "lb", "gram": "g", "grams": "g",
        "gr": "g", "kilogram": "kg", "kilograms": "kg", "milliliter": "ml", "milliliters": "ml",
        "millilitre": "ml", "millilitres": "ml", "liter": "l", "liters": "l", "litre": "l", "litres": "l",
        "inches": "inch", "pints": "pint", "quarts": "quart", "gallons": "gallon"
    ]

    static func canonicalUnit(_ raw: String) -> String {
        let unit = raw.trimmingCharacters(in: .whitespaces).lowercased()
        if let alias = aliases[unit] { return alias }
        for (singular, plural) in plurals where plural == unit { return singular }
        return unit
    }

    static func unitInfo(_ unit: String, name: String) -> UnitInfo? {
        if unit == "stick" { return name.lowercased().contains("butter") ? butterStick : nil }
        return units[unit]
    }

    /// The unit's system, or nil for spoons, counts and words: used to tell which lines can be converted.
    static func system(ofUnit rawUnit: String, name: String) -> UnitSystem? {
        unitInfo(canonicalUnit(rawUnit), name: name)?.system
    }

    // MARK: - Grams in a cup (dry ingredients)

    /// Grams in one US cup (240 ml). One source for every number: King Arthur Baking's ingredient weight
    /// chart (read 9 Nov 2026; flour, sugar and butter also match EZ Recipe Calc). Not in the chart, so not
    /// here: arborio rice, lentils, farro, chopped walnuts. Matched against the
    /// ingredient's whole main name, never a single word: "almond flour" is not "flour". Liquids stay in ml.
    private static let gramsPerCupTable: [(pattern: String, grams: Double)] = [
        ("almond (flour|meal)", 96),
        ("oat flour", 92),
        ("(sweet|glutinous) rice flour", 120),
        ("(white )?rice flour", 142),
        ("semolina( flour)?", 163),
        ("whole wheat pastry flour|whole-wheat pastry flour|graham flour", 96),
        ("whole wheat flour|whole-wheat flour", 113),
        ("(white )?rye flour", 106),
        ("(bread|cake) flour", 120),
        ("(all-purpose|plain|ap)( white)? flour|flour", 120),
        ("(cornstarch|corn starch|cornflour)", 112),
        ("potato starch", 152),
        ("(light |dark )?brown sugar", 213),
        ("(confectioners'?|confectioners’|powdered|icing) sugar", 113),
        ("(granulated |white |caster |cane )?sugar", 198),
        ("butter", 226),
        ("(unsweetened )?(dutch-process(ed)? )?(cocoa|cocoa powder|cacao powder)", 84),
        ("(old-fashioned |quick |quick-cooking )?(rolled )?oats", 89),
        ("(long-grain|basmati|jasmine)( white)? rice", 198),
        ("quinoa", 177),
        ("panko( bread ?crumbs)?", 50),
        ("(dried |dry |plain )?bread ?crumbs", 112),
        ("(parmesan|parmigiano-reggiano|parmigiano|pecorino|pecorino romano)( cheese)?", 100),
        ("(cheddar|mozzarella|monterey jack|jack|swiss|gruyère|gruyere)( cheese)?", 113),
        ("feta( cheese)?", 114),
        ("(whole[- ]milk )?ricotta( cheese)?", 227),
        ("cream cheese", 227),
        ("(mayonnaise|mayo)", 226),
        ("sour cream", 227),
        ("(semisweet |semi-sweet |bittersweet |dark |milk |white )?chocolate chips", 170),
        ("(plain |greek |whole[- ]milk |full-fat )*yogurt", 227),
        ("walnuts|walnut halves", 128),
        ("sliced almonds", 86),
        ("(whole )?almonds", 142),
        ("cashews", 113),
        ("(diced )?pecans", 114),
        ("sunflower seeds", 140),
        ("(pepitas|pumpkin seeds)", 160),
        ("dried cranberries", 114),
        ("dried apricots", 128),
        ("raisins", 149),
        ("unsweetened (shredded |flaked )?coconut", 53),
        ("sweetened (shredded |flaked )?coconut", 85),
        ("(creamy |smooth |crunchy )?peanut butter", 270),
        ("tomato paste", 232)
    ]

    private static let gramsPerCupRegexes: [(regex: NSRegularExpression, grams: Double)] = gramsPerCupTable.compactMap { entry -> (regex: NSRegularExpression, grams: Double)? in
        guard let regex = try? NSRegularExpression(pattern: "^(?:" + entry.pattern + ")$") else { return nil }
        return (regex, entry.grams)
    }

    /// Words that don't change what a cup weighs. "Fresh", "sliced" and "chopped" stay: they do.
    private static let ignoredWords: Set<String> = [
        "unsalted", "salted", "softened", "melted", "cold", "room-temperature", "packed", "firmly", "lightly",
        "sifted", "unbleached", "organic", "raw", "toasted", "grated", "shredded", "crumbled", "freshly",
        "finely", "good-quality", "store-bought"
    ]

    /// "Unsalted butter, softened" → 226. Nil when the ingredient isn't in the table.
    static func gramsPerCup(for name: String) -> Double? {
        var main = name.lowercased()
        if let bracket = try? NSRegularExpression(pattern: "\\s*\\([^)]*\\)") {
            main = bracket.stringByReplacingMatches(in: main, range: NSRange(location: 0, length: (main as NSString).length), withTemplate: "")
        }
        main = main.components(separatedBy: ",").first ?? main
        let words = main.split(whereSeparator: { $0 == " " }).map(String.init).filter { !ignoredWords.contains($0) }
        let phrase = words.joined(separator: " ")
        let range = NSRange(location: 0, length: (phrase as NSString).length)
        return gramsPerCupRegexes.first { $0.regex.firstMatch(in: phrase, range: range) != nil }?.grams
    }

    // MARK: - Converting one line

    /// The amount for one ingredient line at a servings scale, in a unit system. Nil when the unit isn't a
    /// measurement or a count unit ("medium", "to taste", "whole"), or the amount is 0: the caller shows the
    /// line as before. `unit` is the measurement alone, without ", minced".
    static func measure(amount: Double, unit rawUnit: String, name: String,
                        altAmount: Double? = nil, altUnit: String? = nil, altEach: Bool = false, altApprox: Bool = false,
                        scale: Double, system: UnitSystem) -> Measure? {
        let unit = canonicalUnit(rawUnit)
        let value = amount * scale
        guard value > 0 else { return nil }
        let isOriginal = abs(scale - 1) < 0.0001
        let info = unitInfo(unit, name: name)

        // The author's second amount: per item ("each") it doesn't scale with the servings
        var alt: (value: Double, unit: String, info: UnitInfo?)?
        if let altAmount, altAmount > 0, let altUnit {
            let altCanonical = canonicalUnit(altUnit)
            alt = (altEach ? altAmount : altAmount * scale, altCanonical, unitInfo(altCanonical, name: name))
        }
        let altIsOriginal = isOriginal || altEach

        /// The second amount as shown after the name: "about 425 g each", "8 cloves".
        func altDetail(converting: Bool) -> (text: String, converted: Bool)? {
            guard let alt else { return nil }
            let prefix = altApprox ? "about " : ""
            let suffix = altEach ? " each" : ""
            guard let altInfo = alt.info else {
                return (prefix + countText(alt.value, unit: alt.unit) + suffix, false)
            }
            if altEach && !altApprox && converting && altInfo.system != system && altInfo.dimension == .weight && system == .metric {
                return (metricText(alt.value * altInfo.base, dimension: .weight, fine: true) + suffix, true)
            }
            let shown = format(alt.value, unit: alt.unit, info: altInfo, name: name, system: system,
                               isOriginal: altIsOriginal, converting: converting)
            var text = shown.text
            // A spoon as the second amount needs no ml: "12 g (1 tbsp)", not "12 g (1 tbsp (15 ml))"
            if altInfo.isSpoon, let bracket = text.range(of: " (") { text = String(text[..<bracket.lowerBound]) }
            return (prefix + text + suffix, shown.converted)
        }

        // 1. Counts: "2 cans", "8 slices", or a plain number with a weight after the name
        guard let info else {
            guard plurals[unit] != nil || (unit.isEmpty && alt != nil) else { return nil }
            let detail = altDetail(converting: true)
            return Measure(amount: countText(value, unit: unit), detail: detail?.text, isConverted: detail?.converted ?? false)
        }

        // 2. In the reader's system already, or spoons: shown as written, with the author's own second amount
        if info.isSpoon || info.system == system {
            let shown = format(value, unit: unit, info: info, name: name, system: system, isOriginal: isOriginal, converting: false)
            var detail: String?
            if let alt, alt.info?.system != otherSystem(system) || alt.info?.isSpoon == true {
                detail = altDetail(converting: false)?.text
            }
            if shown.hasOwnDetail { detail = nil }
            return Measure(amount: shown.text, detail: detail, isConverted: shown.converted)
        }

        // 3. The other system: the author's own number first ("200 g (7 oz)" → 7 oz; "12 g (1 tbsp)" → 1 tbsp)
        if let alt, let altInfo = alt.info, altInfo.system == system || altInfo.isSpoon {
            let shown = format(alt.value, unit: alt.unit, info: altInfo, name: name, system: system,
                               isOriginal: altIsOriginal, converting: false)
            let text = (altApprox ? "about " : "") + shown.text + (altEach ? " each" : "")
            return Measure(amount: text, detail: nil, isConverted: true)
        }
        // "1 cup (7 oz) kimchi" for a metric reader: the author's weight, in grams, beats a volume
        if system == .metric, info.dimension == .volume, let alt, let altInfo = alt.info,
           altInfo.system == .us, altInfo.dimension == .weight {
            let grams = alt.value * altInfo.base
            return Measure(amount: (altApprox ? "about " : "") + metricText(grams, dimension: .weight), detail: nil, isConverted: true)
        }

        let shown = format(value, unit: unit, info: info, name: name, system: system, isOriginal: false, converting: true)
        var detail: String?
        if let alt, alt.info == nil {
            detail = altDetail(converting: false)?.text      // "450 g (about 2 breasts)", "1 oz (8 cloves)"
        }
        return Measure(amount: shown.text, detail: detail, isConverted: true)
    }

    private static func otherSystem(_ system: UnitSystem) -> UnitSystem { system == .us ? .metric : .us }

    /// One amount in the reader's system: kept as written when it already is (and unscaled), converted otherwise.
    private static func format(_ value: Double, unit: String, info: UnitInfo, name: String, system: UnitSystem,
                               isOriginal: Bool, converting: Bool) -> (text: String, converted: Bool, hasOwnDetail: Bool) {
        if info.isSpoon {
            return (spoonText(value, unit: unit, info: info, name: name, system: system, isOriginal: isOriginal), false, system == .metric && value * info.base >= 15)
        }
        if info.system == system || !converting {
            if isOriginal { return (originalText(value, unit: unit), false, false) }
            return (sameSystemText(value, unit: unit, info: info), false, false)
        }
        let base = value * info.base
        switch (info.dimension, system) {
        case (.volume, .metric):
            if let cupGrams = gramsPerCup(for: name) {
                return (metricText(base / 240 * cupGrams, dimension: .weight), true, false)
            }
            return (metricText(base, dimension: .volume), true, false)
        case (.weight, .metric):
            return (metricText(base, dimension: .weight), true, false)
        case (.weight, .us):
            if let cupGrams = gramsPerCup(for: name) {
                return (usVolumeText(ml: base / cupGrams * 240), true, false)
            }
            // A few grams (1 g star anise, 5 g herbs): "¼ oz" would be several times too much, so they stay grams
            if isTooSmallForOunces(grams: base) {
                return (isOriginal ? originalText(value, unit: unit) : metricText(base, dimension: .weight), false, false)
            }
            return (usWeightText(grams: base), true, false)
        case (.volume, .us):
            return (usVolumeText(ml: base), true, false)
        case (.length, .metric):
            return (cmText(base) + (unit == "inch piece" ? " piece" : ""), true, false)
        case (.length, .us):
            return (inchText(cm: base, piece: unit == "inch piece"), true, false)
        }
    }

    // MARK: - Spoons

    /// Spoons stay spoons in both systems. In metric, a tablespoon or more also shows ml, or grams for the
    /// dry ingredients in the table, because spoon sizes differ (an Australian tablespoon is 20 ml).
    /// Scaled up past 4 tablespoons, metric shows ml or grams instead; US moves up to cups when exact.
    private static func spoonText(_ value: Double, unit: String, info: UnitInfo, name: String,
                                  system: UnitSystem, isOriginal: Bool) -> String {
        let ml = value * info.base
        let grams = gramsPerCup(for: name).map { ml / 240 * $0 }
        if system == .metric && !isOriginal && ml > 60 {
            return grams.map { metricText($0, dimension: .weight) } ?? metricText(ml, dimension: .volume)
        }
        let spoons = isOriginal ? originalText(value, unit: unit) : scaledSpoonText(teaspoons: ml / 5, allowCups: system == .us)
        guard system == .metric, ml >= 15, !spoons.hasSuffix("tsp") else { return spoons }
        let extra = grams.map { metricText($0, dimension: .weight) } ?? metricText(ml, dimension: .volume)
        return "\(spoons) (\(extra))"
    }

    /// 6 tsp → "2 tbsp", 16 tbsp → "1 cup" (only when exact), 5 tbsp → "5 tbsp".
    private static func scaledSpoonText(teaspoons: Double, allowCups: Bool) -> String {
        if allowCups && teaspoons >= 12 {
            let cups = teaspoons / 48
            let snapped = snap(cups, steps: cupSteps)
            if abs(snapped.value - cups) / cups <= 0.03 { return snapped.text + " " + label("cup", for: snapped.value) }
        }
        if teaspoons >= 2.9 {
            let tablespoons = snap(teaspoons / 3, steps: halfSteps)
            return tablespoons.text + " tbsp"
        }
        return snap(teaspoons, steps: teaspoonSteps, minimum: 0.125).text + " tsp"
    }

    // MARK: - Text for each system

    private static let cupSteps: [Double] = [0, 0.25, 1.0 / 3, 0.5, 2.0 / 3, 0.75, 1]
    private static let quarterSteps: [Double] = [0, 0.25, 0.5, 0.75, 1]
    private static let halfSteps: [Double] = [0, 0.5, 1]
    private static let teaspoonSteps: [Double] = [0, 0.125, 0.25, 0.5, 0.75, 1]

    private static let glyphs: [(value: Double, glyph: String)] = [
        (0.125, "⅛"), (0.25, "¼"), (1.0 / 3, "⅓"), (0.375, "⅜"), (0.5, "½"), (0.625, "⅝"), (2.0 / 3, "⅔"),
        (0.75, "¾"), (0.875, "⅞")
    ]
    private static let eighthSteps: [Double] = [0, 0.125, 0.25, 1.0 / 3, 0.375, 0.5, 0.625, 2.0 / 3, 0.75, 0.875, 1]

    /// The app's usual number text ("½", "1½", "225"), or the nearest eighth when that would be decimals.
    private static func numberText(_ value: Double) -> String {
        let number = GroceryFormatter.formatNumber(String(value))
        guard number.contains("."), value < 100 else { return number }
        return snap(value, steps: eighthSteps).text
    }

    /// The nearest kitchen fraction: 1.4 with cup steps → (1.333, "1⅓"). Never 0: at least `minimum`.
    private static func snap(_ value: Double, steps: [Double], minimum: Double? = nil) -> (value: Double, text: String) {
        var whole = value.rounded(.down)
        let fraction = value - whole
        var best = steps[0]
        for step in steps where abs(step - fraction) < abs(best - fraction) { best = step }
        if best >= 1 { whole += 1; best = 0 }
        var snapped = whole + best
        if snapped <= 0 {
            snapped = minimum ?? steps.first(where: { $0 > 0 }) ?? 1
            whole = snapped.rounded(.down)
            best = snapped - whole
        }
        let glyph = glyphs.first(where: { abs($0.value - best) < 0.001 })?.glyph ?? ""
        let wholeText = whole > 0 ? String(Int(whole)) : ""
        let text = wholeText + glyph
        return (snapped, text.isEmpty ? "0" : text)
    }

    /// As the recipe wrote it, the way the app always showed it: 0.5 → "½", 225 → "225".
    private static func originalText(_ value: Double, unit: String) -> String {
        let number = numberText(value)
        return "\(number) \(displayUnit(unit, for: value))"
    }

    /// Scaled but not converted: the same unit, rounded for the kitchen.
    private static func sameSystemText(_ value: Double, unit: String, info: UnitInfo) -> String {
        let base = value * info.base
        if info.system == .metric {
            if info.dimension == .length { return cmText(base) }
            return metricText(base, dimension: info.dimension)
        }
        switch unit {
        case "cup":
            return usVolumeText(ml: base)
        case "oz", "lb":
            return usWeightText(grams: base)
        case "inch", "inch piece":
            return inchText(cm: base, piece: unit == "inch piece")
        default:
            let snapped = snap(value, steps: quarterSteps, minimum: 0.25)
            return snapped.text + " " + displayUnit(unit, for: snapped.value)
        }
    }

    /// Metric, rounded for the kitchen: nearest 1 under 10, 5 under 100, 10 under 500, 25 under 1,000,
    /// then kg or L with one decimal. Never 0. `fine`: nearest 5 under 1,000, for package sizes the way
    /// labels print them (15 oz → 425 g).
    static func metricText(_ value: Double, dimension: Kind, fine: Bool = false) -> String {
        if dimension == .length { return cmText(value) }
        let fineStep: Double = value < 10 ? 1 : 5
        let rounded = (fine && value < 1000) ? max(1, (value / fineStep).rounded() * fineStep) : roundMetric(value)
        if rounded >= 1000 {
            let big = (value / 100).rounded() / 10
            return trimmed(big) + (dimension == .weight ? " kg" : " L")
        }
        return "\(Int(rounded))" + (dimension == .weight ? " g" : " ml")
    }

    private static func roundMetric(_ value: Double) -> Double {
        let step: Double = value < 10 ? 1 : value < 100 ? 5 : value < 500 ? 10 : 25
        return max(1, (value / step).rounded() * step)
    }

    /// US weight: ounces up to about a pound, then pounds in quarters, or one decimal when quarters are off
    /// by more than 5%. Never 0.
    /// Under an ounce, when the nearest ¼ oz is more than 25% off: 10 g is ⅓ oz, not ¼.
    static func isTooSmallForOunces(grams: Double) -> Bool {
        let ounces = grams / 28.3495
        guard ounces > 0, ounces < 1 else { return false }
        let quarter = max(0.25, (ounces * 4).rounded() / 4)
        return abs(quarter - ounces) / ounces > 0.25
    }

    static func usWeightText(grams: Double) -> String {
        let ounces = grams / 28.3495
        if ounces < 15.5 {
            if ounces < 1 { return snap(ounces, steps: quarterSteps, minimum: 0.25).text + " oz" }
            let step: Double = ounces < 4 ? 0.5 : 1
            let snapped = (ounces / step).rounded() * step
            return snap(snapped, steps: halfSteps).text + " oz"
        }
        let pounds = grams / 453.592
        let quarters = (pounds * 4).rounded() / 4
        if abs(quarters - pounds) / pounds <= 0.05 { return snap(quarters, steps: quarterSteps).text + " lb" }
        return trimmed((pounds * 10).rounded() / 10) + " lb"
    }

    /// US volume: teaspoons under a tablespoon, tablespoons under ¼ cup, then cups in ¼ and ⅓. When the
    /// nearest cup fraction is more than 5% off: tablespoons up to ½ cup ("6 tbsp", not "⅓ cup" for 75 g
    /// sugar), above that cups plus tablespoons ("1¼ cups + 2 tbsp").
    static func usVolumeText(ml: Double) -> String {
        let teaspoons = ml / 5
        if teaspoons < 2.9 { return snap(teaspoons, steps: teaspoonSteps, minimum: 0.125).text + " tsp" }
        if teaspoons < 11.5 { return snap(teaspoons / 3, steps: halfSteps).text + " tbsp" }
        let exactCups = teaspoons / 48
        let cups = snap(exactCups, steps: cupSteps)
        if abs(cups.value - exactCups) / exactCups <= 0.05 { return cups.text + " " + label("cup", for: cups.value) }
        let tablespoons = teaspoons / 3
        if tablespoons <= 8.25 { return snap(tablespoons, steps: halfSteps).text + " tbsp" }
        let whole = exactCups.rounded(.down)
        let part = cupSteps.filter { $0 < 1 && $0 <= exactCups - whole + 0.0001 }.max() ?? 0
        let base = snap(whole + part, steps: cupSteps)
        let rest = snap((exactCups - base.value) * 16, steps: halfSteps)
        if rest.value < 0.5 || rest.text == "0" { return base.text + " " + label("cup", for: base.value) }
        return base.text + " " + label("cup", for: base.value) + " + " + rest.text + " tbsp"
    }

    /// Lengths the way recipes write them: ½ inch = 1 cm, 1 inch = 2.5 cm, 9 inches = 23 cm.
    private static let inchToCm: [(inches: Double, cm: String)] = [
        (0.125, "3 mm"), (0.25, "6 mm"), (1.0 / 3, "8 mm"), (0.5, "1 cm"), (2.0 / 3, "1.5 cm"), (0.75, "2 cm"),
        (1, "2.5 cm"), (1.5, "4 cm"), (2, "5 cm"), (2.5, "6 cm"), (3, "7.5 cm"), (4, "10 cm"), (5, "13 cm"),
        (6, "15 cm"), (7, "18 cm"), (8, "20 cm"), (9, "23 cm"), (10, "25 cm"), (11, "28 cm"), (12, "30 cm"),
        (13, "33 cm")
    ]

    private static func cmText(_ cm: Double) -> String {
        let inches = cm / 2.54
        if let known = inchToCm.first(where: { abs($0.inches - inches) < 0.02 }) { return known.cm }
        if cm < 1 { return "\(max(1, Int((cm * 10).rounded()))) mm" }
        return (cm < 5 ? trimmed((cm * 2).rounded() / 2) : "\(Int(cm.rounded()))") + " cm"
    }

    private static func inchText(cm: Double, piece: Bool) -> String {
        let inches = snap(cm / 2.54, steps: quarterSteps, minimum: 0.25)
        return piece ? "\(inches.text)-inch piece" : "\(inches.text) \(inches.value > 1 ? "inches" : "inch")"
    }

    private static func countText(_ value: Double, unit: String) -> String {
        let number = numberText(value)
        return unit.isEmpty ? number : "\(number) \(displayUnit(unit, for: value))"
    }

    // MARK: - Unit names

    /// "cups" above 1, "L" for litres, "2-inch piece".
    private static func displayUnit(_ unit: String, for value: Double) -> String {
        switch unit {
        case "l": return "L"
        case "inch": return value > 1 ? "inches" : "inch"
        case "inch piece": return "inch piece"
        default: return label(unit, for: value)
        }
    }

    private static func label(_ unit: String, for value: Double) -> String {
        value > 1 ? (plurals[unit] ?? unit) : unit
    }

    private static func trimmed(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(value))" : String(format: "%.1f", value)
    }

    // MARK: - Converted-amounts note

    /// The grey note under Ingredients, only when some amounts aren't in the recipe's own units:
    /// "Converted from metric and rounded for the kitchen…", or "Some amounts are converted…" when not all.
    static func conversionNote(convertedCount: Int, convertibleCount: Int, system: UnitSystem) -> String? {
        guard convertedCount > 0 else { return nil }
        let from = system == .us ? UnitSystem.metric.name : UnitSystem.us.name
        if convertedCount < convertibleCount {
            return "Some amounts are converted from \(from) and rounded for the kitchen, so they can differ slightly from the original."
        }
        return "Converted from \(from) and rounded for the kitchen, so amounts can differ slightly from the original."
    }
}

#if DEBUG
// MARK: - Self-check (Xcode only)

extension UnitConverter {

    /// Run with the launch argument "-UnitsSelfCheck YES": converts every ingredient of every bundled recipe in
    /// both systems at several servings and prints anything odd (a 0, long decimals, an unknown measurement).
    static func runSelfCheckIfAsked() {
        guard UserDefaults.standard.bool(forKey: "UnitsSelfCheck") else { return }
        let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? []
        let decoder = JSONDecoder()
        var lines = 0
        var problems: [String] = []
        let measurementWord = try? NSRegularExpression(pattern: "\\b(cups?|oz|lb|g|kg|ml|l|inch)\\b") // spoons need no conversion
        let oddNumber = try? NSRegularExpression(pattern: "(^|\\s)0(\\s|$)|\\d\\.\\d{2}|\\b0 [a-z]")
        for url in urls {
            guard let data = try? Data(contentsOf: url),
                  let recipe = try? decoder.decode(ProcessedRecipe.self, from: data) else { continue }
            for ingredient in recipe.recipe.ingredients {
                let rawUnit = ingredient.ingredientUnit.components(separatedBy: ",").first ?? ""
                for system in [UnitSystem.us, .metric] {
                    for scale in [0.5, 1, 1.5, 2, 3] {
                        lines += 1
                        let result = measure(amount: ingredient.ingredientAmount, unit: rawUnit,
                                             name: ingredient.ingredientName, altAmount: ingredient.altAmount,
                                             altUnit: ingredient.altUnit, altEach: ingredient.altEach ?? false,
                                             altApprox: ingredient.altApprox ?? false, scale: scale, system: system)
                        let line = "\(recipe.recipe.name): \(ingredient.ingredientAmount) \(ingredient.ingredientUnit) \(ingredient.ingredientName) ×\(scale) \(system.rawValue)"
                        guard let result else {
                            let unit = canonicalUnit(rawUnit)
                            let range = NSRange(location: 0, length: (unit as NSString).length)
                            if ingredient.ingredientAmount > 0, measurementWord?.firstMatch(in: unit, range: range) != nil {
                                problems.append("UNREAD  \(line)")
                            }
                            continue
                        }
                        let text = result.combined
                        if oddNumber?.firstMatch(in: text, range: NSRange(location: 0, length: (text as NSString).length)) != nil {
                            problems.append("ODD     \(line) → \(text)")
                        }
                    }
                }
            }
        }
        print("[Units] Self-check: \(lines) conversions, \(problems.count) to look at")
        problems.prefix(200).forEach { print("[Units] \($0)") }
    }
}
#endif

//
//  RecipeIngredientsGridView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct RecipeIngredientsGridView: View {
    @ObservedObject var viewModel: SharedViewModel
    var ingredients: [(Double, String, String)] // (Amount, Unit, Name)
    /// The same ingredients as stored, in the same order: their second amounts ("200 g (7 oz)") for US / Metric.
    var sourceIngredients: [Ingredient] = []
    var servingValue: Double
    
    /// The servings stepper (Pro; free users get a shake and the paywall). Replaces the old Scale slider in 1.3.3.
    var isScaleVisible: Bool = true
    var isPaywallActionable: Bool = true
    /// Ingredient to highlight (opened from that grocery item), in the grocery list's soft orange.
    var highlightedName: String? = nil
    /// Read-only servings ("6 servings"), shown as a chip beside the title when there is no stepper:
    /// opened from the grocery list (cart icon) or in Cooking Mode (people icon).
    var listServingsText: String? = nil
    var servingsChipIcon: String = "cart.fill"
    /// Recipe page, Pro users: "Add to list" right after the Ingredients title opens the grocery picker,
    /// the same as the cart in the top bar. Nil hides it (opened from Groceries, Cooking Mode).
    var onAddToGroceries: (() -> Void)? = nil
    /// Observed, so buying Pro from the paywall this page opened unlocks the stepper at once.
    @ObservedObject private var user = User.shared
    /// US / Metric (1.4): the page redraws when it changes here or in Settings.
    @AppStorage(UnitsSetting.storageKey) private var unitsSettingRaw: String = UnitsSetting.automatic.rawValue

    private var unitSystem: UnitSystem {
        (UnitsSetting(rawValue: unitsSettingRaw) ?? .automatic).system
    }

    /// The stepper's whole servings, kept as the shared scale (servings ÷ the recipe's own), so the cart,
    /// Cooking Mode and everything else that reads the scale keeps working.
    private var servingsBinding: Binding<Int> {
        Binding(
            get: { max(1, Int((viewModel.value * servingValue).rounded())) },
            set: { viewModel.value = Double($0) / servingValue }
        )
    }

    /// Free users see the servings stepper locked (Pro).
    private var isServingsLocked: Bool {
        isScaleVisible && servingValue > 0 && user.subscription == .free
    }

    private func showScalePaywall() {
        if isPaywallActionable {
            PaywallVisibilityManager.show(triggeredBy: .attemptToScaleRecipeIngredients)
        }
    }

    /// "✨ Scale it with Pro" beside the Ingredients title, for free users: purple marks it as an upgrade
    /// feature, apart from the green amounts and the orange servings band. A tap opens the paywall.
    private var scaleWithProChip: some View {
        Button(action: showScalePaywall) {
            HStack(spacing: 5) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                Text("Scale it with Pro")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.purple)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 11)
            .padding(.vertical, 6)
            .background(
                ZStack {
                    Capsule().fill(Color(.systemBackground)) // solid, so the band doesn't show through
                    Capsule().fill(Color.purple.opacity(0.12))
                }
            )
        }
        .buttonStyle(.plain)
        .accessibilityHint("Pro feature. Opens the upgrade screen.")
    }

    /// "🛒 Add to grocery list": a soft green chip at the right of the Ingredients title, opening the grocery picker.
    private func addToListButton(title: String, action: @escaping () -> Void) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 15, weight: .semibold))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.green)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 13)
            .padding(.vertical, 7)
            .background(Capsule().fill(Color.green.opacity(0.12)))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add ingredients to grocery list")
    }

    /// Soft green chip, icon + "6 servings": the amounts below are for these servings.
    private func listServingsChip(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: servingsChipIcon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.green)
        .lineLimit(1)
        .fixedSize()
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Capsule().fill(Color.green.opacity(0.12)))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(servingsChipIcon == "cart.fill" ? "Amounts for \(text), as on your grocery list" : "Amounts for \(text)")
    }

    var body: some View {
        let firstMatch = firstHighlightedIndex // worked out once, not for every row
        
        VStack(alignment: .leading, spacing: 10) {
            // Section title, with the read-only servings chip when there is no stepper
            HStack {
                Text("Ingredients")
                    .font(.title3.bold())
                
                Spacer(minLength: 8)
                
                if let onAddToGroceries, user.subscription == .pro {
                    // The full words; on a narrow iPhone (SE) where they don't fit beside the title, "Add to list".
                    ViewThatFits(in: .horizontal) {
                        addToListButton(title: "Add to grocery list", action: onAddToGroceries)
                        addToListButton(title: "Add to list", action: onAddToGroceries)
                    }
                    // Offered the row's free width first: without it the row split the space with the Spacer,
                    // and the full words never seemed to fit.
                    .layoutPriority(1)
                }
                
                if let listServingsText {
                    listServingsChip(listServingsText)
                }
            }
            .padding(.horizontal)
            
            // Servings stepper, the same row as in the grocery picker
            if isScaleVisible && servingValue > 0 {
                // One orange band: servings, then units
                VStack(spacing: 0) {
                    ServingsStepper(
                        servings: servingsBinding,
                        baseServings: Int(servingValue),
                        bandBleed: 16,
                        isLocked: isServingsLocked,
                        onLockedTap: showScalePaywall
                    )
                    // Free users: "Scale it with Pro" at the right of the title row, dipping onto the band.
                    // An overlay of the band, so it's always drawn in front of it.
                    .overlay(alignment: .topTrailing) {
                        if isServingsLocked {
                            scaleWithProChip
                                .offset(y: -20) // overlaps the band's top by about 9 pt
                        }
                    }
                    .padding(.horizontal)

                    // US / Metric, in the same orange band. Free for everyone, so outside the locked stepper.
                    UnitsRow(system: unitSystem) { unitsSettingRaw = $0.rawValue }
                    .padding(.horizontal)
                }
            }

            // "Converted from metric and rounded for the kitchen…": only when amounts aren't the recipe's own units
            if let note = conversionNote {
                ConversionNoteView(text: note)
                    .padding(.horizontal)
                    .padding(.top, 2)
            }
            
            // Ingredients List
            VStack {
                // Identified by position: some recipes list the same ingredient twice with different amounts
                ForEach(Array(ingredients.enumerated()), id: \.offset) { (index, ingredient) in
                    let (amount, unit, name) = ingredient
                    HStack(spacing: 5) {
                        // Bullet Point
                        Text("•")
                            .font(.subheadline.bold())
                        
                        // Attributed Ingredient String
                        Text(attributedIngredientString(index: index, amount: amount, unit: unit, name: name))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange.opacity(isHighlighted(name) ? 0.12 : 0))
                            .padding(.horizontal, 8)
                            .padding(.vertical, -4) // taller than the row, without moving the other rows
                    )
                    .id(index == firstMatch ? Self.highlightedRowID : "ingredient-\(index)")
                }
            }
            .padding(.top, 6)
        }
    }
    
    /// Scroll target for the highlighted row, so the recipe page can bring it on screen.
    static let highlightedRowID = "highlightedIngredient"
    
    /// Formatted lines, kept: the recipe page can redraw many times while scrolling.
    private static let lineCache: NSCache<NSString, IngredientLineBox> = {
        let cache = NSCache<NSString, IngredientLineBox>()
        cache.countLimit = 500
        return cache
    }()
    
    /// "to 12": the rest of a range ("6 to 12 eggs"). Compiled once.
    private static let rangeRestRegex = try! NSRegularExpression(pattern: "^to\\s*\\d")
    
    /// Same name, ignoring capital letters and surrounding spaces.
    /// Brackets don't count: a grocery item added before 1.4 says "cut into 1-inch pieces",
    /// the recipe now says "cut into 1-inch (2.5 cm) pieces".
    static func isSameIngredient(_ a: String, _ b: String) -> Bool {
        isExactIngredient(a, b) || bracketFree(a).caseInsensitiveCompare(bracketFree(b)) == .orderedSame
    }

    static func isExactIngredient(_ a: String, _ b: String) -> Bool {
        a.trimmingCharacters(in: .whitespaces)
            .caseInsensitiveCompare(b.trimmingCharacters(in: .whitespaces)) == .orderedSame
    }

    private static func bracketFree(_ name: String) -> String {
        name.replacingOccurrences(of: "\\([^)]*\\)", with: " ", options: .regularExpression)
            .split(separator: " ").joined(separator: " ")
            .replacingOccurrences(of: " ,", with: ",")
    }
    
    /// The row the recipe page scrolls to: the first one that matches.
    private var firstHighlightedIndex: Int? {
        ingredients.firstIndex { isHighlighted($0.2) }
    }
    
    /// Recipe units that are really cooking words ("chopped", "for serving"): shown after the name instead.
    private static let wordingPrefixes = [
        "for ", "to ", "as ", "plus ", "optional", "divided", "chopped", "finely", "roughly", "coarsely", "thinly",
        "sliced", "minced", "beaten", "diced", "grated", "peeled", "crushed", "halved", "quartered", "cubed",
        "shredded", "juiced", "zested", "melted", "softened", "torn", "trimmed", "drained", "rinsed", "boiled"
    ]
    
    private static func isWording(_ unit: String) -> Bool {
        let lowered = unit.lowercased()
        // "to 12" is the rest of a range ("6 to 12 eggs"), so it stays with the amount
        if rangeRestRegex.firstMatch(in: lowered, range: NSRange(location: 0, length: (lowered as NSString).length)) != nil {
            return false
        }
        return wordingPrefixes.contains { lowered.hasPrefix($0) }
    }
    
    /// "cloves, minced" → ("cloves", "minced"). A comma inside brackets stays: "g (1 cup, packed)".
    private static func splitUnitNote(_ unit: String) -> (unit: String, note: String?) {
        guard let comma = unit.firstIndex(of: ","), !unit[..<comma].contains("(") else { return (unit, nil) }
        let note = unit[unit.index(after: comma)...].trimmingCharacters(in: .whitespaces)
        return (unit[..<comma].trimmingCharacters(in: .whitespaces), note.isEmpty ? nil : note)
    }
    
    private func isHighlighted(_ name: String) -> Bool {
        guard let highlightedName else { return false }
        // The exact name when a row has it, so "Olive oil" doesn't also light up "Olive oil (for pesto)"
        if ingredients.contains(where: { Self.isExactIngredient($0.2, highlightedName) }) {
            return Self.isExactIngredient(name, highlightedName)
        }
        return Self.isSameIngredient(name, highlightedName)
    }
    
    /// The amount for one line in the reader's units, or nil when its unit isn't a measurement
    /// ("medium", "to taste"): those lines read as before.
    private func convertedMeasure(index: Int, amount: Double, unit: String, name: String) -> UnitConverter.Measure? {
        let trimmed = unit.trimmingCharacters(in: .whitespaces)
        guard amount > 0, !Self.isWording(trimmed) else { return nil }
        let source = sourceIngredients.indices.contains(index) ? sourceIngredients[index] : nil
        return UnitConverter.measure(amount: amount, unit: Self.splitUnitNote(trimmed).unit, name: name,
                                     altAmount: source?.altAmount, altUnit: source?.altUnit,
                                     altEach: source?.altEach ?? false, altApprox: source?.altApprox ?? false,
                                     scale: viewModel.value, system: unitSystem)
    }

    /// The grey note under the band, when some amounts aren't in the recipe's own units.
    private var conversionNote: String? {
        var converted = 0
        var convertible = 0
        for (index, ingredient) in ingredients.enumerated() {
            let (amount, unit, name) = ingredient
            let parts = Self.splitUnitNote(unit.trimmingCharacters(in: .whitespaces))
            guard amount > 0, UnitConverter.system(ofUnit: parts.unit, name: name) != nil else { continue }
            convertible += 1
            if convertedMeasure(index: index, amount: amount, unit: unit, name: name)?.isConverted == true { converted += 1 }
        }
        return UnitConverter.conversionNote(convertedCount: converted, convertibleCount: convertible, system: unitSystem)
    }

    /// Built once per line and kept: the recipe page can redraw many times while scrolling.
    /// The key holds the servings scale and the units, so a switch never shows an old line.
    private func attributedIngredientString(index: Int, amount: Double, unit: String, name: String) -> AttributedString {
        let source = sourceIngredients.indices.contains(index) ? sourceIngredients[index] : nil
        let alt = "\(source?.altAmount ?? 0)\(source?.altUnit ?? "")\(source?.altEach ?? false)\(source?.altApprox ?? false)"
        let key = "\(amount)\u{1F}\(viewModel.value)\u{1F}\(unitSystem.rawValue)\u{1F}\(unit)\u{1F}\(name)\u{1F}\(alt)" as NSString
        if let cached = Self.lineCache.object(forKey: key) { return cached.line }
        let line = makeIngredientLine(index: index, amount: amount, unit: unit, name: name)
        Self.lineCache.setObject(IngredientLineBox(line), forKey: key)
        return line
    }
    
    /// "1½ cups Flour", "Kosher salt, to taste": numbers formatted like the grocery list
    /// (½ instead of 0.5, 1½ instead of 1.50), but the recipe's own wording ("clove, minced") is kept for cooking.
    private func makeIngredientLine(index: Int, amount baseAmount: Double, unit: String, name: String) -> AttributedString {
        var attributedString = AttributedString()
        let unit = unit.trimmingCharacters(in: .whitespaces)
        let amount = baseAmount * viewModel.value
        let converted = convertedMeasure(index: index, amount: baseAmount, unit: unit, name: name)

        // Green before the name ("1½ cups", "2", "pinch"); grey after it (", chopped", ", to taste")
        let measure: String
        let note: String?
        if let converted {
            measure = converted.amount          // "1½ cups", "120 g", "3 tbsp (40 g)", "2 cans"
            note = [converted.detail, Self.splitUnitNote(unit).note].compactMap { $0 }.joined(separator: ", ").nilIfEmpty
        } else if amount > 0 {
            let number = GroceryFormatter.formatNumber(String(amount))
            if Self.isWording(unit) {
                measure = number                // "2 chopped Scallions" → "2 Scallions, chopped"
                note = unit
            } else {
                // "3 cloves, minced Garlic" → "3 cloves Garlic, minced"; "2 tablespoons" → "2 tbsp" (one spelling, like the grocery list)
                let parts = Self.splitUnitNote(unit)
                measure = "\(number) \(GroceryFormatter.shortUnits(parts.unit))".trimmingCharacters(in: .whitespaces)
                note = parts.note
            }
        } else if unit.first?.isNumber == true || ["pinch", "dash", "splash", "handful"].contains(unit.lowercased()) {
            measure = GroceryFormatter.shortUnits(unit) // no amount, but the unit reads as one: "pinch", "1 tbsp"
            note = nil
        } else {
            measure = ""                        // "to taste", "for serving", or nothing
            note = unit.isEmpty || unit == "0" ? nil : unit
        }

        if !measure.isEmpty {
            // Semibold like the grocery list; ½ ⅓ ¼ … drawn 35% larger, as on the grocery list, or they're too small to read
            var amountUnitString = AttributedString()
            for character in measure {
                var piece = AttributedString(String(character))
                let isFraction = "½⅓⅔¼¾⅛⅜⅝⅞".contains(character)
                piece.font = .system(size: isFraction ? 16 * 1.35 : 16).weight(.semibold)
                amountUnitString += piece
            }
            amountUnitString.foregroundColor = .green
            attributedString += amountUnitString + AttributedString(" ")
        }

        // The ingredient name, starting with a capital letter like the grocery list
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        var nameString = AttributedString(trimmedName.prefix(1).uppercased() + trimmedName.dropFirst())
        nameString.font = .system(size: 16)
        nameString.foregroundColor = .black
        attributedString += nameString

        // Show the note in grey instead of hiding it: "Kosher salt, to taste"
        if let note {
            var noteString = AttributedString(", " + note)
            noteString.font = .system(size: 16)
            noteString.foregroundColor = .gray
            attributedString += noteString
        }

        return attributedString
    }
}

/// US / Metric inside the orange servings band (1.4): the same look as the servings row, under it.
struct UnitsRow: View {
    let system: UnitSystem
    let onChange: (UnitSystem) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "ruler")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.orange)
                .frame(width: 38, height: 38)
                .background(Circle().fill(Color.orange.opacity(0.16)))

            Text("Units")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                option("US", .us)
                option("Metric", .metric)
            }
            .padding(3)
            .background(Capsule().fill(Color(.secondarySystemGroupedBackground)))
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
        }
        .padding(.vertical, 10)
        .overlay(alignment: .top) {
            Rectangle().fill(Color.orange.opacity(0.18)).frame(height: 1)
        }
        .background(Color.orange.opacity(0.09).padding(.horizontal, -16))
        .padding(.top, -1) // joins the servings band above it
        .sensoryFeedback(.selection, trigger: system)
    }

    private func option(_ title: String, _ value: UnitSystem) -> some View {
        let isSelected = system == value
        return Button {
            guard !isSelected else { return }
            withAnimation(.easeInOut(duration: 0.2)) { onChange(value) }
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .orange)
                .frame(minWidth: 64, minHeight: 33)
                .background(Capsule().fill(isSelected ? Color.orange : Color.clear))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(value == .us ? "US units" : "Metric units")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// "ⓘ Converted from metric and rounded for the kitchen…", grey, under the band.
struct ConversionNoteView: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 15, weight: .medium))
                .padding(.top, 1)
            Text(text)
                .font(.system(size: 14))
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        .accessibilityElement(children: .combine)
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}

/// A formatted line kept in an NSCache, which only holds objects.
private final class IngredientLineBox {
    let line: AttributedString
    init(_ line: AttributedString) { self.line = line }
}

struct RecipeIngredientsGridView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeIngredientsGridView(
            viewModel: SharedViewModel(),
            ingredients: [
                (1, "cup", "Flour"),
                (2, "tbsp", "Sugar"),
                (3, "tsp", "Salt"),
                (0, "", "Butter"),
                (3, "cup", "Milk"),
                (5, "", "Eggs")
            ],
            servingValue: 2
        )
        
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

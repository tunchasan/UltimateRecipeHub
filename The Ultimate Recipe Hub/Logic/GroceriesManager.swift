//
//  GroceryItem.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 15.01.2025.
//

import SwiftUI
import Combine
import Foundation

struct GroceryItem: Identifiable, Codable {
    let id: UUID // Unique identifier
    var firstText: String   // quantity, e.g. "2 cups" (empty when there is none)
    var secondText: String  // name, e.g. "flour"
    var isChecked: Bool
    /// The recipe the item came from. Nil for typed items and for items added before 1.2.2;
    /// optional, so lists saved by older versions still load.
    var recipeID: String?
    var recipeName: String?
    /// The servings the amount is for: the recipe's servings × the scale it was added at (4 × 1.5 → 6).
    /// The long-press panel shows it ("From Lemon Chicken · 6 servings"). Nil for typed and older items.
    var servings: Double?
    
    init(firstText: String, secondText: String, isChecked: Bool = false, recipeID: String? = nil, recipeName: String? = nil, servings: Double? = nil) {
        self.id = UUID() // Automatically generate a unique ID
        self.firstText = firstText
        self.secondText = secondText
        self.isChecked = isChecked
        self.recipeID = recipeID
        self.recipeName = recipeName
        self.servings = servings
    }
}

class GroceriesManager: ObservableObject {
    
    // Singleton instance
    static let shared = GroceriesManager()
    
    @Published private(set) var groceries: [GroceryItem] = []
    
    private let userDefaultsKey = "groceries"
    
    init() {
        loadGroceriesFromUserDefaults()
    }
    
    /// `scale` is the recipe page's servings scale: ×1.5 adds the amounts the page shows, not the recipe's base amounts.
    func addGroceries(from ingredients: [Ingredient], recipeID: String? = nil, recipeName: String? = nil, serves: Int? = nil, scale: Double = 1) -> Bool {
        
        if User.shared.subscription == .free {
            PaywallVisibilityManager.show(triggeredBy: .attemptToAddIngredientsToGroceries)
            return false
        }
        
        let servings = serves.flatMap { $0 > 0 ? Double($0) * scale : nil } // e.g. 4 servings × 1.5 = 6

        let newGroceries = ingredients.map { ingredient in
            let amount = ingredient.ingredientAmount * scale // the amount the recipe page shows

            // Format the amount
            let formattedAmount: String
            if amount.truncatingRemainder(dividingBy: 1) == 0 {
                formattedAmount = String(format: "%.0f", amount) // Remove .0 if whole number
            } else if amount < 1 {
                formattedAmount = fractionalString(from: amount) // Convert fractional amounts
            } else {
                formattedAmount = String(amount) // full value: the list then rounds it exactly like the recipe page does
            }

            // Combine the formatted amount and unit
            // Amount 0 means "to taste", "for serving", "as needed"...: keep only that word, never "0"
            let firstText = (amount == 0
                ? ingredient.ingredientUnit
                : "\(formattedAmount) \(ingredient.ingredientUnit)"
            ).trimmingCharacters(in: .whitespaces)

            return GroceryItem(
                firstText: firstText,
                secondText: ingredient.ingredientName,
                recipeID: recipeID,
                recipeName: recipeName,
                servings: servings
            )
        }

        // Append new groceries and save
        groceries.append(contentsOf: newGroceries)
        saveGroceriesToUserDefaults()
        return true
    }

    // MARK: - Custom items (v1.2.2)

    /// Set to true to make typing your own items a Pro feature (free users then see the paywall).
    static let customItemsRequirePro = false

    /// True when the current user may add their own items; shows the paywall otherwise.
    func canAddCustomItems() -> Bool {
        if GroceriesManager.customItemsRequirePro && User.shared.subscription == .free {
            PaywallVisibilityManager.show(triggeredBy: .attemptToAddIngredientsToGroceries)
            return false
        }
        return true
    }

    /// Adds an item the user typed (e.g. "Milk") to the top of the list.
    /// Returns false when the text is empty or the user can't add items.
    @discardableResult
    func addCustomItem(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, canAddCustomItems() else { return false }

        let parts = GroceriesManager.splitQuantity(from: trimmed)
        guard !parts.name.isEmpty else { return false }

        groceries.insert(GroceryItem(firstText: parts.quantity, secondText: parts.name), at: 0)
        saveGroceriesToUserDefaults()
        return true
    }

    /// Saves an edit made in the bar (long press → Edit). Lossless where possible:
    /// - text unchanged → nothing changes;
    /// - text still starts with the item's amount ("4 tbsp …") → that amount is kept exactly;
    /// - text still ends with its note (", to taste") → that note is kept exactly;
    /// - otherwise the text is read like a newly typed item.
    @discardableResult
    func updateItem(id: UUID, with text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let index = groceries.firstIndex(where: { $0.id == id }) else { return false }

        let item = groceries[index]
        if trimmed == item.editableText { return true }

        let display = item.display
        var parts: (quantity: String, name: String)
        if display.isMeasured, trimmed.hasPrefix(display.quantity + " ") {
            parts = (display.quantity, String(trimmed.dropFirst(display.quantity.count + 1)))
        } else if !display.isMeasured, !display.quantity.isEmpty, trimmed.hasSuffix(", " + display.quantity) {
            parts = (display.quantity, String(trimmed.dropLast(display.quantity.count + 2)))
        } else {
            parts = GroceriesManager.splitQuantity(from: trimmed)
        }
        parts.name = parts.name.trimmingCharacters(in: .whitespaces)
        guard !parts.name.isEmpty else { return false }

        groceries[index].firstText = parts.quantity
        groceries[index].secondText = parts.name
        saveGroceriesToUserDefaults()
        return true
    }

    /// Long press → "Remove all from <recipe>".
    func removeItems(fromRecipe recipeID: String) {
        groceries.removeAll { $0.recipeID == recipeID }
        saveGroceriesToUserDefaults()
    }

    func itemCount(fromRecipe recipeID: String) -> Int {
        groceries.filter { $0.recipeID == recipeID }.count
    }

    /// Splits typed text into a quantity and a name, so typed items look like recipe items:
    /// "2 milk" → ("2", "milk"), "500g flour" → ("500 g", "flour"), "1 1/2 cups sugar" → ("1 1/2 cups", "sugar"),
    /// "2x milk" / "milk x2" → ("2", "milk"), "6 to 12 eggs" → ("6 to 12", "eggs"), "1½ cups sugar" → ("1½ cups", "sugar").
    /// Text without a quantity stays a plain name: "Paper towels" → ("", "Paper towels").
    static func splitQuantity(from text: String) -> (quantity: String, name: String) {
        // Units seen in the recipe data, so an edited recipe item keeps its amount ("200 grams", "1 pound").
        let units = "kg|kilograms?|g|grams?|gr|mg|ml|milliliters?|millilitres?|l|liters?|litres?|lt|cl|dl|oz|ounces?|lbs?|pounds?|cups?|tbsp|tbs|tablespoons?|tsp|teaspoons?|quarts?|pints?|packs?|packets?|packages?|cans?|bottles?|bags?|boxes|box|jars?|dozen|pieces?|pcs|bunch(?:es)?|slices?|loaf|loaves|cloves?|heads?|sticks?|sprigs?|stalks?|handfuls?|pinch(?:es)?|dash(?:es)?|sheets?|whole|small|medium|large"
        let number = "\\d+\\s*(?:-|to)\\s*\\d+|\\d+\\s+\\d+/\\d+|\\d+/\\d+|\\d*[½¼¾⅓⅔⅛]|\\d+(?:[.,]\\d+)?"
        let ns = text as NSString
        let range = NSRange(location: 0, length: ns.length)

        // Leading quantity: "2 milk", "500g flour", "1/2 cup sugar", "2x milk"
        let leading = "^(\(number))\\s*(?:((?:\(units))(?:\\s+each)?)\\b|[x×](?=\\s))?\\s+(.+)$"
        if let regex = try? NSRegularExpression(pattern: leading, options: [.caseInsensitive]),
           let match = regex.firstMatch(in: text, range: range) {
            let amount = ns.substring(with: match.range(at: 1))
            let unitRange = match.range(at: 2)
            let unit = unitRange.location != NSNotFound ? " " + ns.substring(with: unitRange) : ""
            let name = ns.substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces)
            return (amount + unit, name)
        }

        // Trailing count: "milk x2", "eggs × 12"
        let trailing = "^(.+?)\\s+[x×]\\s*(\\d+)$"
        if let regex = try? NSRegularExpression(pattern: trailing, options: [.caseInsensitive]),
           let match = regex.firstMatch(in: text, range: range) {
            return (ns.substring(with: match.range(at: 2)), ns.substring(with: match.range(at: 1)))
        }

        return ("", text)
    }

    /// Converts a fractional double to a string representation (e.g., 0.5 -> "1/2").
    /// - Parameter value: The fractional double.
    /// - Returns: A string representation of the fraction.
    private func fractionalString(from value: Double) -> String {
        switch value {
        case 0.5: return "1/2"
        case 0.33: return "1/3"
        case 0.66: return "2/3"
        case 0.25: return "1/4"
        case 0.75: return "3/4"
        default: return String(value) // Default to string if no matching case
        }
    }
    
    func toggleCheckStatus(for id: UUID) {
        if let index = groceries.firstIndex(where: { $0.id == id }) {
            groceries[index].isChecked.toggle()
            saveGroceriesToUserDefaults()
        }
    }
    
    func removeGrocery(by id: UUID) {
        if let index = groceries.firstIndex(where: { $0.id == id }) {
            groceries.remove(at: index)
            saveGroceriesToUserDefaults()
        }
    }
    
    func clearAll() {
        groceries.removeAll()
        saveGroceriesToUserDefaults()
    }
    
    func uncheckedGroceriesText() -> String {
        groceries
            .filter { !$0.isChecked }
            .map { (item: GroceryItem) -> String in
                let display = item.display
                if display.quantity.isEmpty { return display.name }
                // "2 Milk", but "Salt (to taste)"
                return display.isMeasured ? "\(display.quantity) \(display.name)" : "\(display.name) (\(display.quantity))"
            }
            .joined(separator: "\n")
    }
    
    private func saveGroceriesToUserDefaults() {
        if let data = try? JSONEncoder().encode(groceries) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadGroceriesFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedGroceries = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceries = savedGroceries
        }
    }
}

// MARK: - Grocery list display cleanup (v1.2.2)

/// What a grocery row shows, cleaned from the raw recipe text.
struct GroceryDisplay {
    let name: String
    let quantity: String
    /// True for an amount to buy ("2", "500 g", "1½ cups"); false for words like "to taste" or "for serving".
    let isMeasured: Bool
}

/// Cleans recipe ingredient text for the grocery list; the recipe page keeps the full wording.
/// It runs when a row is drawn, so lists saved before 1.2.2 are cleaned too.
enum GroceryFormatter {

    /// Words that say how to use an ingredient rather than how much to buy.
    private static let notePrefixes = ["to taste", "to serve", "to garnish", "as needed", "as desired", "optional",
                                       "divided", "plus ", "if desired", "if needed", "or more", "for ", "drizzle"]

    /// Preparation words that don't matter when shopping ("1 finely chopped" → "1").
    private static let prepWords: Set<String> = [
        "chopped", "finely", "roughly", "coarsely", "thinly", "sliced", "minced", "beaten", "diced", "grated",
        "peeled", "crushed", "halved", "quartered", "cubed", "shredded", "juiced", "zested", "melted", "softened",
        "trimmed", "rinsed", "drained", "lightly", "freshly", "torn", "seeded", "cored"
    ]

    private static let fractionGlyphs: [(value: Double, glyph: String)] = [
        (1.0 / 8, "⅛"), (1.0 / 4, "¼"), (1.0 / 3, "⅓"), (1.0 / 2, "½"), (2.0 / 3, "⅔"), (3.0 / 4, "¾")
    ]

    private static let numberRegex = try! NSRegularExpression(
        pattern: "^(\\d+\\s+\\d+/\\d+|\\d+/\\d+|\\d*[½¼¾⅓⅔⅛]|\\d+(?:[.,]\\d+)?)(?:\\s+(.+))?$")
    private static let bracketRegex = try! NSRegularExpression(pattern: "\\s*\\(([^)]*)\\)")

    /// One spelling per unit, so recipes from different sources read the same:
    /// "2 tablespoons" → "2 tbsp", "200 grams (7 ounces)" → "200 g (7 oz)". Joined words like "15-ounce can" stay.
    /// Only for the unit that goes with an amount, never for names or notes ("Gram flour", "for the pound cake").
    private static let unitShortForms: [(regex: NSRegularExpression, short: String)] = {
        let forms: [(pattern: String, short: String)] = [
            // The short form itself is listed too, so "Tbsp" and "OZ" read "tbsp" and "oz"
            (pattern: "teaspoons?|tsps?", short: "tsp"),
            (pattern: "tablespoons?|tbsps?|tbs|tbl", short: "tbsp"),
            (pattern: "grams?|gr|g", short: "g"),
            (pattern: "kilograms?|kgs?", short: "kg"),
            (pattern: "ounces?|oz", short: "oz"),
            (pattern: "pounds?|lbs?", short: "lb"),
            (pattern: "milliliters?|millilitres?|mls?", short: "ml"),
            (pattern: "liters?|litres?|lt|l", short: "L")   // "L", as "1 l" reads like "11"
        ]
        return forms.map { form in
            // A whole word at the start, after a space or after "(": not "15-ounce can" or "tablespoon-size"
            let regex = try! NSRegularExpression(
                pattern: "(^|[\\s(])(?:\(form.pattern))(?![A-Za-z-])", options: [.caseInsensitive])
            return (regex: regex, short: form.short)
        }
    }()

    static func shortUnits(_ text: String) -> String {
        unitShortForms.reduce(text) { result, unit in
            unit.regex.stringByReplacingMatches(
                in: result, range: NSRange(location: 0, length: (result as NSString).length), withTemplate: "$1\(unit.short)")
        }
    }
    private static let trailingNoteRegex = try! NSRegularExpression(
        pattern: "\\s+(to taste|to serve|as needed|as desired|for serving|for garnish)$", options: [.caseInsensitive])

    static func display(quantity rawQuantity: String, name rawName: String) -> GroceryDisplay {
        let (name, note) = splitNote(from: rawName)
        var quantity = cleanQuantity(rawQuantity)
        if quantity.isEmpty, let note {
            quantity = note // "kosher salt, to taste" with no amount → "to taste" on the right
        }
        return GroceryDisplay(
            name: capitalizingFirstLetter(name),
            quantity: quantity,
            isMeasured: quantity.first?.isNumber ?? false
        )
    }

    static func isNote(_ text: String) -> Bool {
        let lowered = text.trimmingCharacters(in: .whitespaces).lowercased()
        return notePrefixes.contains { lowered.hasPrefix($0) }
    }

    private static func isPrep(_ text: String) -> Bool {
        let words = text.lowercased().split(whereSeparator: { !$0.isLetter }).map(String.init)
        return !words.isEmpty && words.allSatisfy { prepWords.contains($0) }
    }

    /// "kosher salt, to taste" → ("kosher salt", "to taste"), "Dark rum (optional)" → ("Dark rum", "optional"),
    /// "Salt to taste" → ("Salt", "to taste"), "olive oil, divided" → ("olive oil", "divided").
    static func splitNote(from rawName: String) -> (name: String, note: String?) {
        var name = rawName.trimmingCharacters(in: .whitespaces)
        var note: String?

        // 1. Notes in brackets: "(optional)", "(for brushing)"
        let bracketMatches = bracketRegex.matches(in: name, range: NSRange(location: 0, length: (name as NSString).length))
        for match in bracketMatches.reversed() {
            let inner = (name as NSString).substring(with: match.range(at: 1))
            if isNote(inner) {
                note = note ?? inner.trimmingCharacters(in: .whitespaces)
                name = (name as NSString).replacingCharacters(in: match.range, with: "")
            }
        }

        // 2. Notes after a comma: "…, to taste", "…, divided", "…, plus more for dusting"
        let parts = name.components(separatedBy: ",")
        if let index = parts.indices.dropFirst().first(where: { isNote(parts[$0]) }) {
            note = note ?? parts[index...].joined(separator: ",").trimmingCharacters(in: .whitespaces)
            name = parts[..<index].joined(separator: ",")
        }

        // 3. A note at the end without a comma: "Kosher salt to taste"
        let nsName = name as NSString
        if let match = trailingNoteRegex.firstMatch(in: name, range: NSRange(location: 0, length: nsName.length)),
           match.range.location > 0 {
            note = note ?? nsName.substring(with: match.range(at: 1))
            name = nsName.substring(to: match.range.location)
        }

        name = name.trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
        while name.contains("  ") {
            name = name.replacingOccurrences(of: "  ", with: " ")
        }
        if name.isEmpty {
            return (rawName.trimmingCharacters(in: .whitespaces), nil)
        }
        return (name, note)
    }

    /// "1.50 cups" → "1½ cups", "0.125 tsp" → "⅛ tsp", "1 finely chopped" → "1", "1 stick, chopped" → "1 stick",
    /// "1 for serving" → "for serving", "500 milliliters (2 cups)" → "500 milliliters", "0 to taste" → "to taste".
    static func cleanQuantity(_ raw: String) -> String {
        var text = raw.trimmingCharacters(in: .whitespaces)
        if text == "0" { return "" }
        if text.hasPrefix("0 ") { text = String(text.dropFirst(2)) }
        text = bracketRegex
            .stringByReplacingMatches(in: text, range: NSRange(location: 0, length: (text as NSString).length), withTemplate: "")
            .trimmingCharacters(in: .whitespaces)

        let nsText = text as NSString
        guard let match = numberRegex.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return text // a word such as "to taste" or "pinch", or nothing
        }
        let number = formatNumber(nsText.substring(with: match.range(at: 1)))
        guard match.range(at: 2).location != NSNotFound else { return number }

        let rest = nsText.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespaces)
        let unit = rest.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? ""
        if isNote(rest) { return rest }                      // "1 for serving" → "for serving"
        if unit.isEmpty || isPrep(unit) { return number }    // "1 finely chopped" → "1"
        return "\(number) \(shortUnits(unit))"               // "1 clove, minced" → "1 clove"
    }

    /// "1.50" → "1½", "0.125" → "⅛", "1 1/2" → "1½", "1,5" → "1½", "500" → "500".
    static func formatNumber(_ token: String) -> String {
        if fractionGlyphs.contains(where: { $0.glyph == token }) { return token }
        let pieces = token.split(separator: " ")
        let value: Double?
        if pieces.count == 2, let whole = Double(pieces[0]), let fraction = fractionValue(String(pieces[1])) {
            value = whole + fraction
        } else if let fraction = fractionValue(token) {
            value = fraction
        } else {
            value = Double(token.replacingOccurrences(of: ",", with: "."))
        }
        guard let value else { return token }
        return format(value)
    }

    private static func fractionValue(_ text: String) -> Double? {
        let pieces = text.split(separator: "/")
        guard pieces.count == 2, let top = Double(pieces[0]), let bottom = Double(pieces[1]), bottom != 0 else { return nil }
        return top / bottom
    }

    private static func format(_ value: Double) -> String {
        let whole = Int(value)
        let fraction = value - Double(whole)
        if fraction < 0.02 { return "\(whole)" }
        if fraction > 0.98 { return "\(whole + 1)" }
        if let match = fractionGlyphs.first(where: { abs($0.value - fraction) < 0.03 }) {
            return whole == 0 ? match.glyph : "\(whole)\(match.glyph)"
        }
        var text = String(format: "%.2f", value) // e.g. 0.38; no trailing zeros
        while text.hasSuffix("0") { text.removeLast() }
        if text.hasSuffix(".") { text.removeLast() }
        return text
    }

    private static func capitalizingFirstLetter(_ text: String) -> String {
        guard let first = text.first else { return text }
        return first.uppercased() + text.dropFirst()
    }
}

extension GroceryItem {
    /// Cleaned name and quantity for the list (see GroceryFormatter).
    var display: GroceryDisplay {
        GroceryFormatter.display(quantity: firstText, name: secondText)
    }

    /// What the edit bar starts with: "4 tbsp Olive oil", "Kosher salt, to taste" or "Milk".
    var editableText: String {
        let shown = self.display
        if shown.quantity.isEmpty { return shown.name }
        return shown.isMeasured ? "\(shown.quantity) \(shown.name)" : "\(shown.name), \(shown.quantity)"
    }
}

extension GroceriesManager {
    /// Returns the count of unchecked grocery items.
    func uncheckedItemCount() -> Int {
        return groceries.filter { !$0.isChecked }.count
    }
}

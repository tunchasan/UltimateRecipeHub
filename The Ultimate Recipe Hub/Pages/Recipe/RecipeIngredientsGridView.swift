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
    var servingValue: Double
    
    var isScaleVisible: Bool = true
    var isPaywallActionable: Bool = true
    /// Ingredient to highlight (opened from that grocery item), in the grocery list's soft orange.
    var highlightedName: String? = nil

    @State var isSliderDisable: Bool = false
    @State var isSliderVisible: Bool = false
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        let firstMatch = firstHighlightedIndex // worked out once, not for every row
        
        VStack(alignment: .leading, spacing: 10) {
            // Section Title with Scale Button
            HStack {
                Text("Ingredients")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if isScaleVisible {
                    let isProUser = User.shared.subscription == .pro
                    Button(action: {
                        
                        if isProUser {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isSliderVisible.toggle()
                            }
                        }
                        
                        else {
                            startShakeAnimation()
                            if isPaywallActionable {
                                PaywallVisibilityManager.show(triggeredBy: .attemptToScaleRecipeIngredients)
                            }
                        }
                        
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: isProUser ? "slider.horizontal.3" : "lock.fill")
                                .font(.system(size: 18).bold())
                                .foregroundColor(.green)
                                .padding(.horizontal, 10)
                            
                            Text("Scale")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.green)
                        }
                        .offset(x: shakeOffset)
                        .animation(.linear(duration: 0.1), value: shakeOffset) // One-time shake animation
                    }
                }
            }
            .padding(.horizontal)
            
            // Scale Slider
            if isSliderVisible {

                VStack(alignment: .leading) {
                    HStack {
                        Text("Scale: \(viewModel.value, specifier: "%.2f")x")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Text("\(viewModel.value * servingValue, specifier: "%.2f") serving(s)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    Slider(value: $viewModel.value, in: 0.25...10.0, step: 0.25)
                        .padding(.horizontal)
                        .tint(.green)
                }
                .padding(.top, 10)
            }
            
            // Ingredients List
            VStack {
                // Identified by position: some recipes list the same ingredient twice with different amounts
                ForEach(Array(scaledIngredients.enumerated()), id: \.offset) { (index, ingredient) in
                    let (amount, unit, name) = ingredient
                    HStack(spacing: 5) {
                        // Bullet Point
                        Text("•")
                            .font(.subheadline.bold())
                        
                        // Attributed Ingredient String
                        Text(attributedIngredientString(amount: amount, unit: unit, name: name))
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
            .padding(.top, isSliderVisible ? 0 : 10)
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
    static func isSameIngredient(_ a: String, _ b: String) -> Bool {
        a.trimmingCharacters(in: .whitespaces)
            .caseInsensitiveCompare(b.trimmingCharacters(in: .whitespaces)) == .orderedSame
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
        return Self.isSameIngredient(name, highlightedName)
    }
    
    private func startShakeAnimation() {
        shakeOffset = 10
        isSliderDisable = true
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shakeOffset = -10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            shakeOffset = 0
            isSliderDisable = false
        }
    }
    
    /// Scaled ingredients based on the `scaleValue`.
    private var scaledIngredients: [(Double, String, String)] {
        return ingredients.map { (amount, unit, name) in
            let scaledAmount = amount * viewModel.value
            return (scaledAmount, unit, name)
        }
    }
    
    /// Built once per line and kept: the recipe page can redraw many times while scrolling.
    private func attributedIngredientString(amount: Double, unit: String, name: String) -> AttributedString {
        let key = "\(amount)\u{1F}\(unit)\u{1F}\(name)" as NSString
        if let cached = Self.lineCache.object(forKey: key) { return cached.line }
        let line = makeIngredientLine(amount: amount, unit: unit, name: name)
        Self.lineCache.setObject(IngredientLineBox(line), forKey: key)
        return line
    }
    
    /// "1½ cups Flour", "Kosher salt, to taste": numbers formatted like the grocery list
    /// (½ instead of 0.5, 1½ instead of 1.50), but the recipe's own wording ("clove, minced") is kept for cooking.
    private func makeIngredientLine(amount: Double, unit: String, name: String) -> AttributedString {
        var attributedString = AttributedString()
        let unit = unit.trimmingCharacters(in: .whitespaces)

        // Green before the name ("1½ cups", "2", "pinch"); grey after it (", chopped", ", to taste")
        let measure: String
        let note: String?
        if amount > 0 {
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
            var amountUnitString = AttributedString(measure)
            amountUnitString.font = .system(size: 16).weight(.semibold) // semibold like the grocery list
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

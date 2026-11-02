//
//  GroceryPickerSheet.swift
//  The Ultimate Recipe Hub
//
//  Grocery picker (1.3.3): the recipe page's cart opens this sheet instead of adding every ingredient.
//  Everything opens ticked; the user unticks what they have, picks the servings, then adds.
//  - Recipe already on the list: the sheet opens as it was added (servings, items), says so at the top, and
//    "Update grocery list" replaces that recipe's items. Never two copies of one recipe.
//  - Same item on the list for something else: a note shows it. Typed by the user ("Milk"): starts unticked,
//    it likely covers this recipe. For another recipe: stays ticked, that amount is spoken for.
//

import SwiftUI

// MARK: - Shared ingredient checklist

/// One row of an ingredient checklist.
struct ChecklistItem: Identifiable {
    /// The ingredient's position in the recipe: a recipe can list the same ingredient twice.
    let id: Int
    let name: String
    let quantity: String
    /// An amount to buy ("2", "1½ cups"), shown green; words like "to taste" are grey.
    let isMeasured: Bool
    /// Shown greyed and can't be ticked.
    var isLocked = false
    /// A small line under the name, e.g. "On your list · 2 tbsp for Cookies".
    var note: String? = nil
}

/// A list of ingredients to tick. Shared: the grocery picker uses it now, Quick Check (2.0) will reuse it.
struct IngredientChecklist: View {
    let items: [ChecklistItem]
    @Binding var picked: Set<Int>

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(items) { item in
                row(item)
                Divider()
                    .padding(.leading, 36) // box (24) + spacing (12): starts under the name
            }
        }
        .sensoryFeedback(.selection, trigger: picked)
    }

    private func row(_ item: ChecklistItem) -> some View {
        let isPicked = picked.contains(item.id) && !item.isLocked
        return Button {
            if isPicked { picked.remove(item.id) } else { picked.insert(item.id) }
        } label: {
            HStack(alignment: .center, spacing: 12) {
                box(isPicked: isPicked, isLocked: item.isLocked)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(.system(size: 16))
                        .foregroundColor(item.isLocked ? .secondary : .primary)
                        .multilineTextAlignment(.leading)
                    if let note = item.note {
                        Text(note)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if !item.quantity.isEmpty {
                    Text.withReadableFractions(item.quantity, size: 16, weight: item.isMeasured ? .semibold : .regular)
                        .foregroundColor(item.isLocked || !item.isMeasured ? .secondary : .green)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .allowsHitTesting(!item.isLocked) // not .disabled: that would grey the row a second time
        .accessibilityAddTraits(isPicked ? [.isSelected] : [])
        .accessibilityHint(item.note ?? "")
    }

    /// The grocery list's check circle: green when ticked; grey and filled when it's locked (already on the list).
    private func box(isPicked: Bool, isLocked: Bool) -> some View {
        Image(systemName: isPicked || isLocked ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 22))
            .foregroundColor(isLocked ? Color(.systemGray3) : (isPicked ? .green : .gray))
            .contentTransition(.symbolEffect(.replace))
            .frame(width: 24, height: 24)
    }
}

// MARK: - Grocery picker sheet

struct GroceryPickerSheet: View {
    let recipe: ProcessedRecipe
    /// Called once the list changed: how many items, and whether the recipe's items were replaced.
    var onAdded: (_ count: Int, _ isUpdate: Bool) -> Void = { _, _ in }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var groceriesManager = GroceriesManager.shared
    @State private var servings: Int
    @State private var picked: Set<Int> = []
    /// This recipe's items already on the list, when the sheet opened.
    private let existingCount: Int
    private let existingServings: Double?

    /// `pageScale`: the recipe page's servings scale, so the sheet opens at the servings the page shows.
    init(recipe: ProcessedRecipe, pageScale: Double,
         onAdded: @escaping (_ count: Int, _ isUpdate: Bool) -> Void = { _, _ in }) {
        self.recipe = recipe
        self.onAdded = onAdded
        let manager = GroceriesManager.shared
        let existing = manager.items(fromRecipe: recipe.id)
        existingCount = existing.count
        existingServings = existing.first?.servings
        let ingredients = Array(recipe.recipe.ingredients.enumerated())

        if existing.isEmpty {
            // New: everything ticked, so a full shop is one tap. The one exception is an item the user typed
            // themselves ("Milk"): that's usually their general shopping, so it likely covers this recipe too and
            // starts unticked. An item on the list for another recipe stays ticked: that amount is for that recipe.
            _servings = State(initialValue: max(1, Int((Double(recipe.recipe.serves) * pageScale).rounded())))
            let elsewhere = manager.itemsToBuyByName(excludingRecipe: recipe.id)
            let toBuy = ingredients
                .filter { ingredient in
                    let other = elsewhere[GroceriesManager.matchKey(ingredient.element.ingredientName)]
                    return other == nil || other?.recipeID != nil
                }
                .map { $0.offset }
            _picked = State(initialValue: Set(toBuy))
        } else {
            // Already on the list: open as it was added, so changing the servings is all it takes.
            let added = existing.first?.servings ?? Double(recipe.recipe.serves) * pageScale
            _servings = State(initialValue: max(1, Int(added.rounded())))
            let addedNames = Set(existing.map { GroceriesManager.matchKey($0.secondText) })
            let wasAdded = ingredients
                .filter { addedNames.contains(GroceriesManager.matchKey($0.element.ingredientName)) }
                .map { $0.offset }
            _picked = State(initialValue: Set(wasAdded))
        }
    }

    /// The recipe is already on the list: the button updates it instead of adding a second copy.
    private var isUpdate: Bool { existingCount > 0 }

    private var baseServings: Int { recipe.recipe.serves }

    private var scale: Double {
        baseServings > 0 ? Double(servings) / Double(baseServings) : 1
    }

    /// Each ingredient as it would land on the grocery list, with a note when the list already has it
    /// for something else.
    private var items: [ChecklistItem] {
        let elsewhere = groceriesManager.itemsToBuyByName(excludingRecipe: recipe.id)
        return recipe.recipe.ingredients.enumerated().map { index, ingredient in
            let display = GroceriesManager.groceryItem(for: ingredient, scale: scale).display
            let other = elsewhere[GroceriesManager.matchKey(ingredient.ingredientName)]
            return ChecklistItem(
                id: index,
                name: display.name,
                quantity: display.quantity,
                isMeasured: display.isMeasured,
                note: other.map(Self.onListNote)
            )
        }
    }

    /// "On your list · 2 tbsp for Cookies", "On your list · 1 (your item)", "On your list (your item)".
    private static func onListNote(_ item: GroceryItem) -> String {
        let quantity = item.display.quantity
        let amount = quantity.isEmpty ? "" : " · \(quantity)"
        if let recipeName = item.recipeName {
            return "On your list\(amount) for \(recipeName)"
        }
        return "On your list\(amount) (your item)"
    }

    private func servingsText(_ servings: Double) -> String {
        servings == 1 ? "1 serving" : "\(servings.formatted(.number.precision(.fractionLength(0...2)))) servings"
    }

    var body: some View {
        let items = self.items
        let selectable = items.filter { !$0.isLocked }.map(\.id)
        let count = selectable.filter { picked.contains($0) }.count
        let isAllPicked = !selectable.isEmpty && count == selectable.count

        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                header
                if baseServings > 0 {
                    ServingsStepper(servings: $servings, baseServings: baseServings, bandBleed: 20)
                }
                // Live count, and one button to tick or untick everything.
                HStack(alignment: .firstTextBaseline) {
                    Text("\(count) of \(selectable.count) selected")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText(value: Double(count)))
                    Spacer(minLength: 8)
                    Button(isAllPicked ? "Clear all" : "Select all") {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            picked = isAllPicked ? [] : Set(selectable)
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.green)
                    .disabled(selectable.isEmpty)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 28)
            .padding(.bottom, 6)

            Divider()

            ScrollView {
                IngredientChecklist(items: items, picked: $picked)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
            }

            addButton(count: count)
        }
        .presentationDetents([.fraction(0.85), .large])
        .presentationDragIndicator(.visible)
    }

    /// The recipe name as the title, and what to do in one line under it.
    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.recipe.name)
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
                if isUpdate {
                    // Says up front that the button updates this recipe's items, so no confirmation is needed.
                    Label {
                        Text("Already on your list\(existingServings.map { " · " + servingsText($0) } ?? "")")
                    } icon: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.orange)
                }
                Text(isUpdate
                     ? "Cooking for a different crowd? Change what you need, and we'll update your list 🛒"
                     : "Peek in your kitchen, untick what you already have, and we'll add the rest 🛒")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(Color(.systemGray6)))
            }
            .accessibilityLabel("Close")
        }
    }

    private func addButton(count: Int) -> some View {
        VStack(spacing: 0) {
            Divider()
            Button {
                savePicked()
            } label: {
                HStack(spacing: 8) {
                    if count > 0 {
                        Image(systemName: isUpdate ? "arrow.triangle.2.circlepath" : "cart.badge.plus")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    Text(count == 0 ? "Select items to add"
                         : (isUpdate ? "Update grocery list (\(count))" : "Add to grocery list (\(count))"))
                        .font(.system(size: 17, weight: .bold))
                        .contentTransition(.numericText(value: Double(count)))
                }
                .foregroundColor(count == 0 ? .secondary : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(RoundedRectangle(cornerRadius: 16).fill(count == 0 ? Color(.systemGray5) : Color.green))
                .animation(.easeInOut(duration: 0.2), value: count == 0)
            }
            .disabled(count == 0)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
    }

    /// Adds the ticked ingredients, or replaces this recipe's items when it's already on the list.
    private func savePicked() {
        let chosen = recipe.recipe.ingredients.enumerated()
            .filter { picked.contains($0.offset) }
            .map { $0.element }
        guard !chosen.isEmpty else { return }

        let serves = baseServings > 0 ? baseServings : nil
        let isSaved = isUpdate
            ? groceriesManager.replaceGroceries(
                fromRecipe: recipe.id, with: chosen, recipeName: recipe.recipe.name, serves: serves, scale: scale)
            : groceriesManager.addGroceries(
                from: chosen, recipeID: recipe.id, recipeName: recipe.recipe.name, serves: serves, scale: scale)
        if isSaved {
            onAdded(chosen.count, isUpdate)
            dismiss()
        }
    }
}

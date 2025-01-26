//
//  RecipePlanCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct RecipePlanCard: View {
    var model: ProcessedRecipe
    var slotName: String
    var isActionable: Bool = true
    var action: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                NavigationLink(
                    destination: RecipeDetails(model: model)
                        .navigationBarTitleDisplayMode(.inline),
                    
                    label: {
                        RoundedImage(
                            imageUrl: model.recipe.name,
                            cornerRadius: 12,
                            action: {
                                action()
                            }
                        )
                    }
                )
                .buttonStyle(PlainButtonStyle())
                .frame(maxHeight: 170)
                // Only include the context menu if `isActionable` is true
                .if(isActionable) { view in
                    view.contextMenu {
                        Button {
                            // Swap action
                        } label: {
                            Label("Swap", systemImage: "repeat")
                        }
                        
                        Button {
                            // Mark as eaten action
                        } label: {
                            Label("Eaten", systemImage: "checkmark")
                        }
                    }
                }
            }

            VStack(spacing: 2) {
                Text("\(slotName) • \(model.recipe.calories) Calories")
                    .font(.system(size: 12).bold())
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(model.recipe.name)
                    .font(.system(size: 12))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 170, height: 235)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Helper View Modifier for Conditional Views
extension View {
    /// Applies a modifier conditionally
    /// - Parameters:
    ///   - condition: A boolean that determines if the modifier should be applied.
    ///   - transform: A closure that modifies the view if the condition is true.
    /// - Returns: The original view or the modified view based on the condition.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct RecipePlanCard_Previews: PreviewProvider {
    static var previews: some View {
        // Example recipe ID
        let recipeID = "0000000001"
        
        // Fetch the recipe from RecipeSourceManager
        if let model = RecipeSourceManager.shared.findRecipe(byID: recipeID) {
            return AnyView(
                RecipePlanCard(
                    model: model,
                    slotName: "Breakfast",
                    action: {
                        print("Tapped on recipe with ID: \(recipeID)")
                    }
                )
                .previewLayout(.sizeThatFits)
                .padding()
            )
        } else {
            return AnyView(
                Text("Recipe not found for ID: \(recipeID)")
                    .font(.headline)
                    .foregroundColor(.red)
                    .previewLayout(.sizeThatFits)
                    .padding()
            )
        }
    }
}

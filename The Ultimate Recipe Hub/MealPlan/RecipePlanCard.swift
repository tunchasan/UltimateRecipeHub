//
//  RecipePlanCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI
import ConfettiSwiftUI

struct RecipePlanCard: View {
    var date: Date
    var model: ProcessedRecipe
    var slot: MealSlot.MealType
    var isActionable: Bool = true
    var isReplaceMode: Bool = false
    
    var isPro: Bool = false
    var isEaten: Bool = false
    
    @State private var triggerConfetti: Int = 0
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                if isReplaceMode {
                    Button(
                        action: {
                            mealPlanManager.onRecieveReplacedRecipe(
                                replacedRecipe: model,
                                replacedSlot: slot,
                                replacedDate: date
                            )
                        },
                        label: {
                            ZStack{
                                RoundedImage(
                                    imageUrl: model.recipe.name,
                                    cornerRadius: 12
                                )
                                .opacity(0.5)
                                
                                Image(systemName: "repeat")
                                    .font(.system(size: 54).bold())
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 2)
                            }
                        })
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxHeight: 170)
                }
                
                else {
                    NavigationLink(
                        destination: RecipeDetails(
                            model: model,
                            canAddToPlan: false,
                            shouldManageTabBarVisibility: true
                        )
                        .navigationBarTitleDisplayMode(.inline),
                        label: {
                            ZStack{
                                RoundedImage(
                                    imageUrl: model.recipe.name,
                                    cornerRadius: 12
                                )
                                .grayscale(isEaten ? 0.25 : 0)
                                .opacity(isEaten ? 0.75 : 1)

                                if isEaten || isPro {
                                    RecipePlanCardBadges(
                                        isPro: isPro,
                                        isEaten: isEaten
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                }
                            }
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxHeight: 170)
                    
                    // Only include the context menu if `isActionable` is true
                    .if(isActionable && !isReplaceMode) { view in
                        view.contextMenu {
                            Button {
                                mealPlanManager.assignRandomRecipeToReplaceRecipe(
                                    for: date,
                                    in: slot
                                )
                                
                                mealPlanManager.onRecieveReplacedRecipe(
                                    replacedRecipe: model,
                                    replacedSlot: slot,
                                    replacedDate: date,
                                    suggestion: true
                                )
                                
                            } label: {
                                Label("Swap with AI", systemImage: "repeat")
                            }
                            
                            Button {
                                
                                if !isEaten {
                                    triggerConfetti += 1
                                }
                                
                                mealPlanManager.toggleMealEatenStatus(
                                    for: date,
                                    in: slot
                                )
                            } label: {
                                let title = isEaten ? "Not Consumed" : "Consumed"
                                let icon = isEaten ? "circle" : "checkmark.circle.fill"
                                Label(title, systemImage: icon)
                            }
                            
                            Button {
                                FindRecipesManager.shared.startFindingRecipes(
                                    for: date,
                                    slot: slot,
                                    excludeRecipe: model
                                )
                            } label: {
                                Label("Discover", systemImage: "sparkle.magnifyingglass")
                            }
                        }
                    }
                }
            }
            
            VStack(spacing: 2) {
                Text("\(slot.displayName) • \(model.recipe.calories) Calories")
                    .font(.system(size: isEaten ? 14 : 12).bold())
                    .foregroundColor(isEaten ? .orange : .gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(model.recipe.name)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 170, height: 235)
        .buttonStyle(PlainButtonStyle())
        .confettiCannon(trigger: $triggerConfetti)
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

struct RecipePlanCardBadges: View {
    
    var isPro: Bool = false
    var isEaten: Bool = false

    var body: some View {
        HStack {
            
            if isEaten {
                Image(systemName: "fork.knife.circle")
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                    .background(Color.white) // White background
                    .clipShape(Circle()) // Ensure it's circular
                    .shadow(color: .black.opacity(0.8), radius: 2) // Shadow effect
                    .padding(.leading, 4)
                    .padding(.top, 4)
            }

            Spacer()

            if isPro {
                Text("PRO")
                    .frame(width: 50, height: 25)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(12) // Rounded corners
                    .shadow(color: .black.opacity(0.8), radius: 2) // White shadow
                    .padding(.trailing, 4)
            }
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
                    date: Date(),
                    model: model,
                    slot: MealSlot.MealType.breakfast
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

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
    var isEaten: Bool = false

    @State private var triggerConfetti: Int = 0
    @ObservedObject private var user = User.shared
    @ObservedObject private var mealPlanManager = MealPlanManager.shared

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RecipeCardAction()
            }
            
            RecipeCardDetails()
        }
        .frame(width: 170, height: 235)
        .buttonStyle(PlainButtonStyle())
        .confettiCannon(trigger: $triggerConfetti)
    }
    
    // MARK: - Recipe Card Actions
    @ViewBuilder
    private func RecipeCardAction() -> some View {
        if isReplaceMode {
            ReplaceModeView()
        } else if model.recipe.isProSubscription && user.subscription == .free {
            LockedProRecipeView()
        } else {
            NavigationLink(
                destination: RecipeDetails(
                    model: model,
                    canAddToPlan: false,
                    shouldManageTabBarVisibility: true
                )
                .navigationBarTitleDisplayMode(.inline),
                label: {
                    RecipeCardImage()
                }
            )
            .buttonStyle(PlainButtonStyle())
            .frame(maxHeight: 170)
            .contextMenu { RecipeContextMenu() }
        }
    }
    
    // MARK: - Recipe Image View
    private func RecipeCardImage() -> some View {
        ZStack {
            RoundedImage(
                imageUrl: model.recipe.name,
                cornerRadius: 12
            )
            .grayscale(isEaten ? 0.25 : 0)
            .opacity(isEaten ? 0.75 : 1)
            
            let isPro = model.recipe.isProSubscription
            if isEaten || isPro {
                RecipePlanCardBadges(
                    isPro: isPro,
                    isEaten: isEaten
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
    }
    
    // MARK: - Replace Mode View
    private func ReplaceModeView() -> some View {
        Button(action: {
            mealPlanManager.onRecieveReplacedRecipe(
                replacedRecipe: model,
                replacedSlot: slot,
                replacedDate: date
            )
        }) {
            ZStack {
                RoundedImage(imageUrl: model.recipe.name, cornerRadius: 12)
                    .opacity(0.5)
                
                Image(systemName: "repeat")
                    .font(.system(size: 54).bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxHeight: 170)
    }
    
    // MARK: - Locked Pro Recipe View
    private func LockedProRecipeView() -> some View {
        Button(action: {
            PaywallVisibilityManager.show(triggeredBy: .attemptToSeeProRecipeDetails)
        }) {
            RecipeCardImage()
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxHeight: 170)
        .contextMenu { RecipeContextMenu() }
    }
    
    // MARK: - Recipe Details (Title & Calories)
    private func RecipeCardDetails() -> some View {
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
    
    // MARK: - Context Menu Actions
    @ViewBuilder
    private func RecipeContextMenu() -> some View {
        if isActionable && !isReplaceMode {
            if !isEaten {
                Button {
                    mealPlanManager.assignRandomRecipeToReplaceRecipe(for: date, in: slot)
                    mealPlanManager.onRecieveReplacedRecipe(
                        replacedRecipe: model,
                        replacedSlot: slot,
                        replacedDate: date,
                        suggestion: true
                    )
                } label: {
                    Label("Swap with 'AI Coach'", systemImage: "repeat")
                }
            }
            
            if model.recipe.isProSubscription && User.shared.subscription == .pro || !model.recipe.isProSubscription {
                if DateStatus.determine(for: date) == .today {
                    Button {
                        DispatchQueue.main.async {
                            if !isEaten {
                                triggerConfetti += 1
                            }
                        }
                        mealPlanManager.toggleMealEatenStatus(for: date, in: slot)
                    } label: {
                        let title = isEaten ? "Not Eaten" : "Eaten"
                        let icon = isEaten ? "checkmark.circle.fill" : "circle"
                        Label(title, systemImage: icon)
                    }
                }
            }
            
            if !isEaten {
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
                    .padding(.top, 4)
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

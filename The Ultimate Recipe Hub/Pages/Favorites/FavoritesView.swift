//
//  FavoritesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 12.01.2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var favoriteManager = FavoriteRecipesManager.shared
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    /// Slow "breathing" of the empty page's "Browse recipes" button.
    @State private var isBrowseButtonBreathing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        NavigationView {
            VStack {
                if favoriteManager.favoritedRecipeIDs.count == 0 {
                    emptyStateView
                }
                
                else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 30) {
                            ForEach(RecipeSourceManager.shared.resolveRecipes(for: favoriteManager.favoritedRecipeIDs)) { processedRecipe in
                                RecipeCard(
                                    model: processedRecipe,
                                    showFavoriteButton: true,
                                    shouldManageTabVisibility: true)
                            }
                        }
                        .padding(.top, 25)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 15)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .navigationTitle("Favorites")
            
            .onAppear {
                FavoriteRecipesManager.shared.clearFavoritesCount()
            }
        }
    }
    
    /// Illustration width: 88% of the screen (a little narrower than the 90% on the empty grocery list).
    private var emptyArtWidth: CGFloat { UIScreen.main.bounds.width * 0.88 }

    /// No favorites yet, in the style of the empty grocery list and the onboarding pages: the drawing from the
    /// second onboarding page and the "Your list is empty" line near the top; a hint and a gently breathing
    /// "Browse recipes" button where they'd sit if the whole page were one block centred on the screen.
    private var emptyStateView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                emptyArtAndTitle.hidden() // only reserves its height, so the hint and button keep their place

                VStack(spacing: 28) {
                    // The word "heart" followed by the heart itself (as on recipe cards: red circle, white heart), a bit larger than the text.
                    Text("Tap the heart \(Text(Image(systemName: "heart.circle.fill")).font(.system(size: 21)).foregroundColor(.red)) on any recipe to save it here, so the recipes you love are always one tap away.")
                        .font(.system(size: 18))
                        .lineSpacing(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 32)

                    RoundedButton(title: "Browse recipes", maxWidth: 200, action: {
                        HomeSelectionManager.shared.selectedTab = .recipes
                    })
                    // Invitation, as on the grocery list: grows ~6% while a green glow brightens, then settles.
                    // The repeating animation covers only the size and glow, never the button's position.
                    .animation(reduceMotion ? nil : .easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { button in
                        button
                            .scaleEffect(isBrowseButtonBreathing ? 1.06 : 1)
                            .shadow(
                                color: .green.opacity(isBrowseButtonBreathing ? 0.55 : 0.1),
                                radius: isBrowseButtonBreathing ? 16 : 4,
                                y: 4
                            )
                    }
                    .onAppear { isBrowseButtonBreathing = !reduceMotion }
                    .onDisappear { isBrowseButtonBreathing = false }
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Near the top. The drawing is shorter than the grocery one, so it sits a little lower (72 pt instead
            // of 24) to leave about the same gap above the hint as on the grocery list.
            emptyArtAndTitle
                .padding(.top, 72)
        }
    }

    /// The drawing and the "Your list is empty" line.
    private var emptyArtAndTitle: some View {
        VStack(spacing: 0) {
            // The "Healthy Meals" onboarding drawing with its empty margins trimmed (image is 1030×543).
            Image("Favorites Empty")
                .resizable()
                .scaledToFit()
                .frame(width: emptyArtWidth, height: emptyArtWidth * 543 / 1030)
                .accessibilityHidden(true)

            // Same line as the empty grocery list. Smaller than the large "Favorites" title.
            Text("\(Text("Your list").foregroundColor(.green)) is empty")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 8)
        }
    }
}
    
    struct FavoritesPreviews: PreviewProvider {
        static var previews: some View {
            FavoritesView()
        }
    }
    
    /*
     
     struct FavoritesView: View {
     var body: some View {
     NavigationView {
     ScrollView{
     VStack(spacing: 30){
     HStack(spacing: 20) {
     RecipeCard(
     model: RecipeModel(
     name: "Haitian Legim",
     description: "A rich and hearty Haitian vegetable stew.",
     tag1: ["Dinner", "Hearty"],
     tag2: ["Vegetarian", "Comfort Food"],
     serves: 4,
     subscription: "Pro",
     prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
     cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
     mealType: ["Dinner"],
     dishType: "Stew",
     specialConsideration: ["Vegetarian"],
     preparationType: ["Slow Cooked"],
     ingredientsFilter: ["Vegetables"],
     cuisine: "Haitian",
     difficulty: "Intermediate",
     macros: Macros(carbs: 45, protein: 10, fat: 20),
     ingredients: [
     Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
     Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
     ],
     steps: ["Chop vegetables.", "Cook until tender."],
     calories: 200
     ),
     showFavoriteButton: true,
     scale: 1.0,
     action: {
     print("Recipe tapped")
     }
     )
     
     RecipeCard(
     model: RecipeModel(
     name: "Haitian Legim",
     description: "A rich and hearty Haitian vegetable stew.",
     tag1: ["Dinner", "Hearty"],
     tag2: ["Vegetarian", "Comfort Food"],
     serves: 4,
     subscription: "Pro",
     prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
     cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
     mealType: ["Dinner"],
     dishType: "Stew",
     specialConsideration: ["Vegetarian"],
     preparationType: ["Slow Cooked"],
     ingredientsFilter: ["Vegetables"],
     cuisine: "Haitian",
     difficulty: "Intermediate",
     macros: Macros(carbs: 45, protein: 10, fat: 20),
     ingredients: [
     Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
     Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
     ],
     steps: ["Chop vegetables.", "Cook until tender."],
     calories: 200
     ),
     showFavoriteButton: true,
     scale: 1.0,
     action: {
     print("Recipe tapped")
     }
     )
     }
     
     HStack(spacing: 20) {
     RecipeCard(
     model: RecipeModel(
     name: "Haitian Legim",
     description: "A rich and hearty Haitian vegetable stew.",
     tag1: ["Dinner", "Hearty"],
     tag2: ["Vegetarian", "Comfort Food"],
     serves: 4,
     subscription: "Pro",
     prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
     cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
     mealType: ["Dinner"],
     dishType: "Stew",
     specialConsideration: ["Vegetarian"],
     preparationType: ["Slow Cooked"],
     ingredientsFilter: ["Vegetables"],
     cuisine: "Haitian",
     difficulty: "Intermediate",
     macros: Macros(carbs: 45, protein: 10, fat: 20),
     ingredients: [
     Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
     Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
     ],
     steps: ["Chop vegetables.", "Cook until tender."],
     calories: 200
     ),
     showFavoriteButton: true,
     scale: 1.0,
     action: {
     print("Recipe tapped")
     }
     )
     
     RecipeCard(
     model: RecipeModel(
     name: "Haitian Legim",
     description: "A rich and hearty Haitian vegetable stew.",
     tag1: ["Dinner", "Hearty"],
     tag2: ["Vegetarian", "Comfort Food"],
     serves: 4,
     subscription: "Pro",
     prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
     cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
     mealType: ["Dinner"],
     dishType: "Stew",
     specialConsideration: ["Vegetarian"],
     preparationType: ["Slow Cooked"],
     ingredientsFilter: ["Vegetables"],
     cuisine: "Haitian",
     difficulty: "Intermediate",
     macros: Macros(carbs: 45, protein: 10, fat: 20),
     ingredients: [
     Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
     Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
     ],
     steps: ["Chop vegetables.", "Cook until tender."],
     calories: 200
     ),
     showFavoriteButton: true,
     scale: 1.0,
     action: {
     print("Recipe tapped")
     }
     )
     }
     }
     .padding(.top, 25)
     .padding(.bottom, 10)
     .padding(.horizontal, 15)
     }
     .scrollIndicators(.hidden)
     .navigationTitle("Favorites")
     }
     }
     }
     
     struct FavoritesPreviews: PreviewProvider {
     static var previews: some View {
     FavoritesView()
     }
     }
     */

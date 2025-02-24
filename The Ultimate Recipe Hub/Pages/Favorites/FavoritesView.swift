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
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Your favorites list is empty.")
                .font(.title3.bold())
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
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
     sourceURL: "https://example.com",
     imageURL: "Haitian Legim",
     ratingCount: 125,
     reviewCount: 50,
     rating: 4.8,
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
     sourceURL: "https://example.com",
     imageURL: "Haitian Legim",
     ratingCount: 125,
     reviewCount: 50,
     rating: 4.8,
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
     sourceURL: "https://example.com",
     imageURL: "Haitian Legim",
     ratingCount: 125,
     reviewCount: 50,
     rating: 4.8,
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
     sourceURL: "https://example.com",
     imageURL: "Haitian Legim",
     ratingCount: 125,
     reviewCount: 50,
     rating: 4.8,
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

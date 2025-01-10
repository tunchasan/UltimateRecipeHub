//
//  CollectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 3.12.2024.
//

import SwiftUI

struct CollectionView: View {
    var recipeCollection: RecipeCollection

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(recipeCollection.name)
                    .font(.title2.bold())

                Spacer()

                Button(action: {
                    print("See all tapped for collection: \(recipeCollection.name)")
                }) {
                    Text("See All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                }
                .background(.white)
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 2)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -20) {
                    ForEach(recipeCollection.recipes) { recipe in
                        RecipeCard(
                            title: recipe.recipe.name,
                            imageUrl: "Test1",
                            showProBadge: true,
                            scale: 0.8
                        ) {
                            print("Tapped \(recipe.recipe.name)")
                        }
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipes = [
            ProcessedRecipe(
                id: "0001",
                recipe: RecipeModel(
                    name: "Spaghetti with Fried Eggs",
                    description: "Delicious spaghetti with fried eggs.",
                    tag1: ["Dinner", "Quick"],
                    tag2: ["Eggs", "Spaghetti"],
                    sourceURL: "https://example.com",
                    imageURL: "https://example.com/image.jpg",
                    ratingCount: 42,
                    reviewCount: 10,
                    rating: 4.5,
                    serves: 2,
                    subscription: "free",
                    prepTime: TimeInfo(duration: 10, timeUnit: "minutes"),
                    cookTime: TimeInfo(duration: 20, timeUnit: "minutes"),
                    mealType: ["Dinner"],
                    dishType: "Pasta",
                    specialConsideration: ["Vegetarian"],
                    preparationType: ["Quick"],
                    ingredientsFilter: ["Egg"],
                    cuisine: "Italian",
                    difficulty: "Easy",
                    macros: Macros(carbs: 45, protein: 20, fat: 15),
                    ingredients: [
                        Ingredient(ingredientName: "Spaghetti", ingredientAmount: 200, ingredientUnit: "grams")
                    ],
                    steps: ["Boil water.", "Cook spaghetti."],
                    calories: 300
                ),
                processedInformations: ProcessedInformations(
                    isSideDish: false,
                    recipeTypes: ["Dinner"]
                )
            )
        ]

        let sampleCollection = RecipeCollection(
            id: "001",
            name: "Most Popular",
            entries: sampleRecipes.count,
            recipes: sampleRecipes
        )

        CollectionView(recipeCollection: sampleCollection)
    }
}

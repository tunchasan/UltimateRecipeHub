//
//  CollectionDetailsView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct CollectionDetailsView: View {
    var recipeCollection: RecipeCollection
    @State private var navigateToRecipeDetails: Bool = false
    @ObservedObject private var favoriteManager = FavoriteRecipesManager.shared
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 30) {
                ForEach(RecipeSourceManager.shared.resolveRecipes(for: recipeCollection)) { processedRecipe in
                    RecipeCard(
                        model: processedRecipe,
                        showFavoriteButton: favoriteManager.favoritedRecipeIDs.contains(processedRecipe.id),
                        isFavoriteButtonFunctional: false,
                        action: {
                            print("Tapped on \(processedRecipe.recipe.name)")
                        },
                        onAppearDetails: {
                            navigateToRecipeDetails = true
                        },
                        onDissappearDetails: {
                            navigateToRecipeDetails = false
                        }
                    )
                }
            }
            .padding(.top, 25)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(recipeCollection.name)
        .onAppear {
            TabVisibilityManager.hideTabBar()
        }
        .onDisappear(perform: {
            if !navigateToRecipeDetails{
                TabVisibilityManager.showTabBar()
            }
        })
    }
}

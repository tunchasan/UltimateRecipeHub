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
            // Rows 45 pt apart: each card's two-line name runs ~16 pt past the card, so ~29 pt stays clear
            LazyVGrid(columns: gridColumns, spacing: 45) {
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
            .padding(.bottom, 40) // room under the last row's names
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

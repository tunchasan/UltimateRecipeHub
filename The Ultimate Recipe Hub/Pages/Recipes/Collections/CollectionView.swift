//
//  CollectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 3.12.2024.
//

import SwiftUI

struct CollectionView: View {
    var recipeCollection: RecipeCollection
    let recipeManager = RecipeSourceManager()
    @ObservedObject private var favoriteManager = FavoriteRecipesManager.shared
    /// Collection title: 24 pt semibold at the default text size, scaling with Dynamic Type like .title2.
    @ScaledMetric(relativeTo: .title2) private var titleSize: CGFloat = 24

    var body: some View {
        VStack(spacing: 12) { // title row close to its cards (12 + the cards' 16 pt padding = 28 pt)
            HStack {
                Text(recipeCollection.name)
                    .font(.system(size: titleSize, weight: .semibold))
                
                Spacer()
                
                NavigationLink(destination: CollectionDetailsView(recipeCollection: recipeCollection)) {
                    SeeAllLabel()
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 5) {
                    
                    ForEach(recipeManager.resolveRecipes(for: recipeCollection, with: true).prefix(10)) { processedRecipe in
                        RecipeCard(
                            model: processedRecipe,
                            showFavoriteButton: favoriteManager.favoritedRecipeIDs.contains(processedRecipe.id),
                            isFavoriteButtonFunctional: false,
                            shouldManageTabVisibility: true,
                            scale: 0.95)
                    }
                    
                    if recipeCollection.recipes.count > 9 {
                        NavigationLink(destination: CollectionDetailsView(recipeCollection: recipeCollection)) {
                            SeeAllCard(scale: 0.95)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding() // 16 pt all round: room for the cards' shadows
            }
        }
    }
}

/// "See All ›" in the app's green on a soft green pill: clearly tappable, in the style of the green badges on
/// recipe pages (replaces the white box with a heavy shadow). Used by every collection header on the Recipes page.
struct SeeAllLabel: View {
    var body: some View {
        HStack(spacing: 3) {
            Text("See All")
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
        }
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(.green)
        .padding(.vertical, 6)
        .padding(.leading, 12)
        .padding(.trailing, 10)
        .background(Capsule().fill(Color.green.opacity(0.12)))
        .contentShape(Capsule())
    }
}

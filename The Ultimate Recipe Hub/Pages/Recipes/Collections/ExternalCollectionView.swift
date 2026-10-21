//
//  CollectionView 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 9.02.2025.
//

import SwiftUI

struct ExternalCollectionView: View {
    
    @StateObject private var sourceManager = ExternalSourceManager.shared
    /// Collection title: 24 pt semibold at the default text size, scaling with Dynamic Type like .title2.
    @ScaledMetric(relativeTo: .title2) private var titleSize: CGFloat = 24

    var body: some View {
        VStack(spacing: 12) { // title row close to its cards (12 + the cards' 16 pt padding = 28 pt)
            HStack {
                Text("Your Recipes")
                    .font(.system(size: titleSize, weight: .semibold))
                
                Spacer()
                
                NavigationLink(destination: SavedRecipesView()) {
                    SeeAllLabel()
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 5) {
                    
                    ForEach(sourceManager.SavedRecipes.reversed()) { recipe in
                        ExternalCollectionRecipeCard(
                            id: recipe.id,
                            source: recipe.url,
                            scale: 0.95
                        )
                    }
                    
                    if sourceManager.SavedRecipes.count > 9 {
                        NavigationLink(destination: SavedRecipesView()) {
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

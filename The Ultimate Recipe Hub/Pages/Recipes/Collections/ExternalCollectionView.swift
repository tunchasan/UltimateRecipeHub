//
//  CollectionView 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 9.02.2025.
//

import SwiftUI

struct ExternalCollectionView: View {
    
    @StateObject private var sourceManager = ExternalSourceManager.shared

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Your Recipes")
                    .font(.title2.bold())
                
                Spacer()
                
                NavigationLink(destination: SavedRecipesView()) {
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
                .padding()
                .padding(.top, 5)
            }
        }
    }
}

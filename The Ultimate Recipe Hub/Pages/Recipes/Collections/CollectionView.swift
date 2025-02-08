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
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(recipeCollection.name)
                    .font(.title2.bold())
                
                Spacer()
                
                NavigationLink(destination: CollectionDetailsView(recipeCollection: recipeCollection)) {
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
                    
                    ForEach(recipeManager.resolveRecipes(for: recipeCollection, with: true).prefix(10)) { processedRecipe in
                        RecipeCard(
                            model: processedRecipe,
                            scale: 0.95
                        ) {
                            print("Tapped \(processedRecipe.recipe.name)")
                        }
                    }
                    
                    if recipeCollection.recipes.count > 9 {
                        NavigationLink(destination: CollectionDetailsView(recipeCollection: recipeCollection)) {
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

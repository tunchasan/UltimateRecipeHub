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
                HStack(spacing: -20) {
                    ForEach(recipeCollection.recipes.prefix(9)) { processedRecipe in
                        RecipeCard(
                            model: processedRecipe.recipe,
                            scale: 0.8
                        ) {
                            print("Tapped \(processedRecipe.recipe.name)")
                        }
                    }
                    
                    if recipeCollection.recipes.count > 9 {
                        NavigationLink(destination: CollectionDetailsView(recipeCollection: recipeCollection)) {
                            SeeAllCard(scale: 0.8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
}

struct SeeAllCard: View {
    
    var scale: CGFloat = 1
        
    var body: some View {
        
        VStack {
            
            RoundedImage (
                imageUrl: "Test1",
                cornerRadius: 12,
                action: { })
            
            Text("See All Recipes")
                .padding(.top, 1)
                .font(.system(size: 12 * (1 - scale + 1)))
                .multilineTextAlignment(.leading)
                .frame(width: 160, height: 50, alignment: .topLeading) // Limit size and align
                .truncationMode(.tail) // Add "..." if text overflows
        }
        .frame(width: 170, height: 200) // Size of the RecipeCard
        .scaleEffect(scale)
    }
}

struct SeeAllCard_Previews: PreviewProvider {
    static var previews: some View {
        SeeAllCard()
    }
}

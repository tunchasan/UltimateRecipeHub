//
//  CollectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 3.12.2024.
//

import SwiftUI

struct CollectionView: View {
    let recipes: [Recipe] = [
        Recipe(title: "Patricia Wells' Zucchini Carpaccio With Avocado & Pistachios", imageUrl: "1"),
        Recipe(title: "Creamy Garlic Mushroom Chicken", imageUrl: "2"),
        Recipe(title: "Vegan Buddha Bowl", imageUrl: "3"),
        Recipe(title: "Spaghetti Carbonara", imageUrl: "2"),
        Recipe(title: "Avocado Toast", imageUrl: "1"),
        Recipe(title: "Patricia Wells' Zucchini Carpaccio With Avocado & Pistachios", imageUrl: "1"),
        Recipe(title: "Vegan Buddha Bowl", imageUrl: "3")
    ]
    
    var body: some View {
        VStack (spacing: 5){
            HStack {
                // TODO: Anchor text to left corner
                Text("Most Popular Recipts")
                    .font(.title2.bold())
                
                Spacer() // Pushes the button to the right
                
                Button(action: {
                    print("See all tapped!")
                }) {
                    Text("See All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                }
                .background(.white)
                .cornerRadius(5)
                .shadow(radius: 3)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(recipes) { recipe in
                        RecipeCard(
                            title: recipe.title,
                            imageUrl: recipe.imageUrl,
                            showProBadge: true,
                            difficulty: 3
                        ) {
                            print("Tapped \(recipe.title)")
                        }
                        .offset(x:0, y:5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
    }
}

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let imageUrl: String
}

struct RecipeCardScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}

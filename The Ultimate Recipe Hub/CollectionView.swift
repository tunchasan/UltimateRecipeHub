//
//  CollectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 3.12.2024.
//

import SwiftUI

struct CollectionView: View {
    let recipes: [Recipe] = [
        Recipe(title: "Baked Salmon With Brown-Buttered Tomatoes & Basil", imageUrl: "Baked Salmon With Brown-Buttered Tomatoes & Basil"),
        Recipe(title: "Peach & Tomato Salad With Fish Sauce Vinaigrette", imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette"),
        Recipe(title: "Haitian Legim", imageUrl: "Haitian Legim"),
        Recipe(title: "Duck Breast With Blueberry-Port Sauce", imageUrl: "Duck Breast With Blueberry-Port Sauce"),
        Recipe(title: "Paneer and Cauliflower Makhani", imageUrl: "Paneer and Cauliflower Makhani"),
        Recipe(title: "Peruvian Chicken & Basil Pasta (Sopa Seca)", imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)"),
        Recipe(title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic"),
        Recipe(title: "No-Noodle Eggplant Lasagna with Mushroom Ragú", imageUrl: "No-Noodle Eggplant Lasagna with Mushroom Ragú"),
        Recipe(title: "Toasted Farro & Antipasto Salad", imageUrl: "Toasted Farro & Antipasto Salad"),
        Recipe(title: "Beet-Chickpea Cakes With Tzatziki", imageUrl: "Beet-Chickpea Cakes With Tzatziki")
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
                .shadow(color: .black.opacity(0.5), radius: 2, x:1, y:2)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: -20){
                    ForEach(recipes) { recipe in
                        RecipeCard(
                            title: recipe.title,
                            imageUrl: recipe.imageUrl,
                            showProBadge: true,
                            scale: 0.8
                        ) {
                            print("Tapped \(recipe.title)")
                        }
                    }
                }
                .padding(.vertical, 10)
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

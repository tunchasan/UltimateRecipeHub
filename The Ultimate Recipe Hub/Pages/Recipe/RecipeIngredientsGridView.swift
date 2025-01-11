//
//  RecipeIngredientsGridView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct RecipeIngredientsGridView: View {
    var ingredients: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Section Title
            Text("Ingredients")
                .font(.title3.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Ingredients List
            ForEach(ingredients, id: \.1) { (quantity, name) in
                HStack(spacing: 5) {
                    // Bullet Point
                    Text("•")
                        .font(.subheadline.bold())
                    
                    // Attributed Ingredient String
                    Text(attributedIngredientString(quantity: quantity, name: name))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.vertical, 5)
            }
        }
    }
    
    // Function to generate attributed ingredient strings
    private func attributedIngredientString(quantity: String, name: String) -> AttributedString {
        var attributedString = AttributedString()
        
        if !quantity.isEmpty {
            var quantityString = AttributedString(quantity)
            quantityString.font = .system(size: 14).weight(.bold) // Bold font for quantity
            quantityString.foregroundColor = .black
            attributedString += quantityString + AttributedString(" ")
        }
        
        var nameString = AttributedString(name)
        nameString.font = .system(size: 14) // Regular font for name
        nameString.foregroundColor = .black
        attributedString += nameString
        
        return attributedString
    }
}

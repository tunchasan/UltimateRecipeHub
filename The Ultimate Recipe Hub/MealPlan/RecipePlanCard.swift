//
//  RecipePlanCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct RecipePlanCard: View {
    var title: String
    var recipeTypeTitle: String
    var imageUrl: String
    var isActionButtonVisible: Bool = true
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationLink(
                destination: RecipeCard(
                    model: RecipeModel(
                        name: "Haitian Legim",
                        description: "A rich and hearty Haitian vegetable stew.",
                        tag1: ["Dinner", "Hearty"],
                        tag2: ["Vegetarian", "Comfort Food"],
                        sourceURL: "https://example.com",
                        imageURL: "Haitian Legim",
                        ratingCount: 125,
                        reviewCount: 50,
                        rating: 4.8,
                        serves: 4,
                        subscription: "Pro",
                        prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
                        cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
                        mealType: ["Dinner"],
                        dishType: "Stew",
                        specialConsideration: ["Vegetarian"],
                        preparationType: ["Slow Cooked"],
                        ingredientsFilter: ["Vegetables"],
                        cuisine: "Haitian",
                        difficulty: "Intermediate",
                        macros: Macros(carbs: 45, protein: 10, fat: 20),
                        ingredients: [
                            Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
                            Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
                        ],
                        steps: ["Chop vegetables.", "Cook until tender."],
                        calories: 200
                    ),
                    showFavoriteButton: true,
                    scale: 1.0,
                    action: {
                        print("Recipe tapped")
                    }
                ).navigationBarTitleDisplayMode(.inline),
                
                label: {
                    RoundedImage(
                        imageUrl: imageUrl,
                        cornerRadius: 12,
                        action: {
                            action()
                        }
                    )
                }
            )
            .buttonStyle(PlainButtonStyle())
            .frame(maxHeight: 170)
            .contextMenu {
                Button {
                } label: {
                    Label("Swap", systemImage: "repeat")
                }
                
                Button {
                } label: {
                    Label("Eaten", systemImage: "checkmark")
                }
            }
            
            VStack (spacing: 2) {
                Text(recipeTypeTitle + " • 650 Calories")
                    .font(.system(size: 12).bold())
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title)
                    .font(.system(size: 12))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 170, height: 235)
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecipePlanCard_Preview: PreviewProvider {
    static var previews: some View {
        RecipePlanCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans", recipeTypeTitle: "Breakfast",
                       imageUrl: "Duck Breast With Blueberry-Port Sauce",
                       action: { print("Button tapped!")})
    }
}

struct RecipeFunctionButton: View {
    var action: () -> Void // Action to perform on button tap
    var title: String
    var icon: String
    var size: CGFloat = 25 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: -15) {
                
                Text(title)
                    .padding(.trailing, 10)
                    .frame(width: size * 2.5, height: size * 0.9)
                    .font(.system(size: size * 0.55).bold())
                    .foregroundColor(.white)
                    .background(backgroundColor)
                    .cornerRadius(size / 2) // Rounded corners
                
                Image(systemName: icon)
                    .font(.system(size: size * 0.55).bold())
                    .foregroundColor(.black.opacity(0.7))
                    .padding(size * 0.125) // Add padding to make the circle larger than the icon
                    .background(Color.white) // Set the background color
                    .clipShape(Circle()) // Make the background circular
                    .shadow(radius: 5) // Optional shadow for aesthetics
            }
        }
        .cornerRadius(size / 2)
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .black.opacity(0.7), radius: 3)
    }
}

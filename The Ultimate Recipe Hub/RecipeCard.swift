//
//  RecipeCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.12.2024.
//

import SwiftUI

struct RecipeTitle: View {
    var action: () -> Void // Action to perform on button tap
    var title: String
    var backgroundColor: Color = .green // Default background color
    
    var body: some View {
        
        Text(title)
            .padding(.vertical, 2)
            .padding(.horizontal, 10)
            .font(.system(size: 14).bold())
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.7), radius: 3)
    }
}

struct RecipeCard: View {
    
    var model: ProcessedRecipe
    var showFavoriteButton: Bool = false
    var canNavigateTo: Bool = true
    var scale: CGFloat = 1
    var action: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                if canNavigateTo {
                    NavigationLink(
                        destination: RecipeDetails(model: model)
                            .navigationBarTitleDisplayMode(.inline),
                        label: {
                            RoundedImage(
                                imageUrl: model.recipe.name,
                                cornerRadius: 12
                            )
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        action()
                    }) {
                        RoundedImage(
                            imageUrl: model.recipe.name,
                            cornerRadius: 12
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if model.recipe.isProSubscription {
                    RecipeAction(action: { })
                        .offset(x: 32.5, y: -32.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .scaleEffect(0.7)
                }
                
                if showFavoriteButton {
                    Button(action: {
                        withAnimation{
                            FavoriteRecipesManager.shared.removeFromFavorites(recipeID: model.id)
                        }
                    }) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                            .background(.white)
                            .padding(-3)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.8), radius: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: -5, y: -5) // Adjust position
                }
            }
            
            Text(model.recipe.name)
                .padding(.top, 1)
                .font(.system(size: 13 * (1 - scale + 1)))
                .multilineTextAlignment(.leading)
                .frame(width: 160, height: 50, alignment: .topLeading) // Limit size and align
                .lineLimit(2) // Limit text to 2 lines
                .truncationMode(.tail) // Add "..." if text overflows
        }
        .frame(width: 170, height: 200) // Size of the RecipeCard
        .scaleEffect(scale)
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(
            model: ProcessedRecipe(
                id: "1",
                recipe: RecipeModel(
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
                processedInformations: ProcessedInformations(
                    isSideDish: false,
                    recipeTypes: ["Dinner"]
                )
            ),
            showFavoriteButton: true,
            scale: 1.0,
            action: {
                print("Recipe tapped")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

struct RecipeAction: View {
    var action: () -> Void // Action to perform on button tap
    var size: CGFloat = 35 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    
    var body: some View {
        Text("PRO")
            .frame(width: size * 2, height: size)
            .font(.system(size: size * 0.55))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(size / 2) // Rounded corners
            .shadow(color: .white.opacity(0.8), radius: 2) // White shadow
    }
}

struct RoundedImage: View {
    var imageUrl: String
    var size: CGFloat = 172
    var heightFactor: CGFloat = 1
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        Image(imageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size * heightFactor) // Exact size of the image
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.7), radius: 2)
    }
}

struct RecommendedPlanCardView: View {
    var imageUrl: String
    var action: () -> Void
    var width: CGFloat = 365
    var height: CGFloat = 130
    var cornerRadius: CGFloat = 20

    var body: some View {
        ZStack(alignment: .leading) {
            // Background with Border
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white) // White background
                .frame(width: width, height: height)
                .shadow(radius: 3, x: 1, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Stroke border
                )

            // Text Content
            VStack(alignment: .leading, spacing: 12) {
                Text("Hungry for Inspiration?")
                    .font(.system(size: 18).bold())

                Text("Let's create a perfect personalized,\nmeal plan for you.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: action) {
                    Text("Create a meal plan")
                        .font(.system(size: 12).bold())
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.7), radius: 2)
                }
            }
            .padding(15) // Space for text
            
            HStack {
                
                Spacer()

                Image("Recommended Plan")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .clipped()
                    .padding(.trailing, 10)
            }
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Preview
struct RecommendedPlanCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedPlanCardView(
            imageUrl: "TestImage",
            action: { print("Button tapped") }
        )
        .padding()
        .background(Color.gray.opacity(0.1)) // Background for preview
    }
}

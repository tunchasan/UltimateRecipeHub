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
    var isFavoriteButtonFunctional: Bool = true
    var canNavigateTo: Bool = true
    var shouldManageTabVisibility: Bool = false
    var isDirectedFindSuitableRecipes: Bool = false
    var isCookingModeEnableInDetails: Bool = true
    var isShoppingToolbarButtonEnabled: Bool = true
    var scale: CGFloat = 1
    var action: () -> Void = {}
    var onAppearDetails: () -> Void = {}
    var onDissappearDetails: () -> Void = {}
    var onClickAddToMealPlan: () -> Void = {}

    var body: some View {
        VStack {
            ZStack {
                if canNavigateTo {
                    
                    if (model.recipe.isProSubscription && User.shared.subscription == .free) {
                        Button(action: {
                            PaywallVisibilityManager.show(triggeredBy: .attemptToSeeProRecipeDetails)
                        }) {
                            RoundedImage(
                                imageUrl: model.recipe.name,
                                cornerRadius: 12
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    else {
                        NavigationLink(
                            destination: RecipeDetails(
                                model: model,
                                isCookingModeEnable: isCookingModeEnableInDetails,
                                shouldManageTabBarVisibility: shouldManageTabVisibility,
                                isDirectedFindSuitableRecipes: isDirectedFindSuitableRecipes,
                                isShoppingToolbarButtonEnabled: isShoppingToolbarButtonEnabled,
                                onClickAddToMealPlan: onClickAddToMealPlan
                            )
                                .onAppear(perform: {
                                    onAppearDetails()
                                })
                                .onDisappear(perform: {
                                    onDissappearDetails()
                                })
                                .navigationBarTitleDisplayMode(.inline),
                            label: {
                                RoundedImage(
                                    imageUrl: model.recipe.name,
                                    cornerRadius: 12
                                )
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                    
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
                
                if model.recipe.isProSubscription && User.shared.subscription == .free {
                    RecipeAction(action: { })
                        .offset(x: 32.5, y: -32.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .scaleEffect(0.7)
                }
                
                if showFavoriteButton {
                    Button(action: {
                        if isFavoriteButtonFunctional {
                            withAnimation{
                                FavoriteRecipesManager.shared.removeFromFavorites(recipeID: model.id)
                            }
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
            .cornerRadius(size / 2.15) // Rounded corners
            .shadow(color: .black.opacity(0.8), radius: 2) // White shadow
            .padding(.top, 4)
            .padding(.trailing, 4)
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
    var image: String
    var title: String
    var contentVSpace: CGFloat = 15
    var imageSize: CGFloat = 110
    var imageOffsetLeading: CGFloat = 0
    var description: String
    var buttonText: String
    var buttonColor: Color
    var action: () -> Void
    var height: CGFloat = 160
    var cornerRadius: CGFloat = 20

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
                .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
                .shadow(radius: 3, x: 1, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Stroke border
                )

            HStack {
                Spacer()

                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .offset(x: -imageOffsetLeading)
            }

            VStack(alignment: .leading, spacing: contentVSpace) {
                Text(title)
                    .font(.system(size: 20).bold())

                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)

                Button(action: action) {
                    Text(buttonText)
                        .font(.system(size: 15).bold())
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(buttonColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.7), radius: 2)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
        .padding(.horizontal, 15)
    }
}

//
//  RecipeDetails.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 7.12.2024.
//

import SwiftUI

class SharedViewModel: ObservableObject {
    @Published var value: Double = 1.0
}

struct RecipeDetails: View {
    
    var model: ProcessedRecipe
    @State private var showCopyShoppingListConfirmation: Bool = false
    @State private var isFavorited: Bool = false
    @State private var startCooking: Bool = false
    @State private var addToPlan: Bool = false
    @StateObject private var viewModel = SharedViewModel()

    var body: some View {
        VStack (spacing:0){
            ScrollView{
                ZStack{
                    Image("Baked Salmon With Brown-Buttered Tomatoes & Basil")
                        .resizable()
                        .scaledToFill() // Ensures the image fills the available space
                        .frame(height: UIScreen.main.bounds.height * 0.3) // Take 40% of screen height
                        .clipped() // Ensures no overflow
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                    
                    RichButton(title: "Start Cooking",
                               emoji: "",
                               backgroundColor: .green,
                               minHeight: 50,
                               maxWidth: 200,
                               titleFontSize: 18,
                               emojiColor: .white,
                               titleColor: .white,
                               useSystemImage: false,
                               action: { startCooking = true })
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: 25)
                }
                
                VStack(alignment: .leading, spacing: 20) { // Align content to leading
                    Text(model.recipe.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                                        
                    HStack{
                        Text("👨‍🍳  \(String(model.recipe.difficultyType.rawValue))")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                        
                        Text("🧑  \(String(model.recipe.serves))")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                        
                        
                        Text("🥘  \(String(model.recipe.dishType.capitalizedWords))")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("🔔  Prep \(String(model.recipe.prepTime.duration)) \(String(model.recipe.prepTime.timeUnit))")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                        
                        Text("🔔  Cook \(String(model.recipe.cookTime.duration)) \(String(model.recipe.cookTime.timeUnit))")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        RichTextButton(
                            title: String(model.recipe.calories),
                            subTitle: "Calories",
                            titleColor: .green.opacity(0.85),
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        
                        RichTextButton(
                            title: "\(String(model.recipe.macros.protein))g",
                            subTitle: "Protein",
                            titleColor: .green.opacity(0.85),
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        RichTextButton(
                            title: "\(String(model.recipe.macros.carbs))g",
                            subTitle: "Carb",
                            titleColor: .green.opacity(0.85),
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        RichTextButton(
                            title: "\(String(model.recipe.macros.fat))g",
                            subTitle: "Fat",
                            titleColor: .green.opacity(0.85),
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    
                    Text(model.recipe.description)
                        .font(.system(size: 14))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(.green.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 12)
                    
                }
                .padding(.top, 30)
                
                RecipeIngredientsGridView(
                    viewModel: viewModel,
                    ingredients: model.recipe.formattedIngredients,
                    servingValue: Double(model.recipe.serves)
                )
                    .padding(.top, 30)
                
                DirectionsView(
                    ingredientKeywords: model.recipe.ingredients.extractIngredientNames(),
                    directions: model.recipe.steps
                )
                    .padding(.top, 20)
                
                RecipeTagGridView(tags: model.recipe.combinedTags)
                    .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
            
            AddToMealPlanFooter(action: {
                addToPlan = true
            })
        }
        .sheet(isPresented: $addToPlan, onDismiss: {
            addToPlan = false
        }) {
            AddRecipePlan(
                imageName: "No-Noodle Eggplant Lasagna with Mushroom Ragú",
                title: "Baked Salmon With Brown-Buttered Tomatoes & Basil"
            )
        }
        .sheet(isPresented: $startCooking, onDismiss: {
            startCooking = false
        }) {
            DirectionView(
                viewModel: viewModel,
                model: model.recipe,
                imageName: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                title: model.recipe.name
            ) {
                startCooking = false
            }
        }
        .toolbar{
            HStack (spacing:10) {
                Button(action: {
                    GroceriesManager.shared.addGroceries(from: model.recipe.ingredients)
                    showCopyShoppingListConfirmation = true
                    // Haptic feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                }) {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                Button(action: { }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                Button(action: {
                    
                    let favoriteManager = FavoriteRecipesManager.shared
                    
                    if !favoriteManager.isFavorited(recipeID: model.id) {
                        
                        favoriteManager.addToFavorites(recipeID: model.id)
                        
                        isFavorited = true
                    }
                    
                    else {
                        favoriteManager.removeFromFavorites(recipeID: model.id)
                        
                        isFavorited = false
                    }
                    
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
            }
        }
        .overlay(copyConfirmationOverlay, alignment: .top)
        .onAppear(perform: {
            isFavorited = FavoriteRecipesManager.shared.isFavorited(recipeID: model.id)
        })
    }
    
    private var copyConfirmationOverlay: some View {
        Group {
            if showCopyShoppingListConfirmation {
                Text("Added to grocies!")
                    .font(.body.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background(.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showCopyShoppingListConfirmation = false
                            }
                        }
                    }
                
            }
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(
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
            )
        )
        .previewLayout(.sizeThatFits)
    }
}

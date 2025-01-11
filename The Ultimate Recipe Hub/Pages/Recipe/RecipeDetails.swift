//
//  RecipeDetails.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 7.12.2024.
//

import SwiftUI

struct RecipeDetails: View {
    
    var model: RecipeModel
    @State private var startCooking: Bool = false
    @State private var addToPlan: Bool = false
    
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
                    Text(model.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    HStack{
                        Text("\(String(model.difficultyType.rawValue)) • \(String(model.cookTime.duration)) minutes • \(String(model.serves)) servings")
                            .font(.subheadline.bold())
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                    }
                    
                    HStack {
                        RichTextButton(
                            title: String(model.calories),
                            subTitle: "Calories",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        
                        RichTextButton(
                            title: String(model.macros.protein),
                            subTitle: "Protein",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        RichTextButton(
                            title: String(model.macros.carbs),
                            subTitle: "Carb",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        RichTextButton(
                            title: String(model.macros.fat),
                            subTitle: "Fat",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    
                    Text(model.description)
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
                .padding(.top, 25)
                
                RecipeIngredientsGridView(ingredients: model.formattedIngredients)
                    .padding(.top, 30)
                
                DirectionsView(directions: model.steps)
                    .padding(.top, 20)
                
                RecipeTagGridView(tags: model.combinedTags)
                    .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
            
            ServingOptionsView(addToPlanAction: {
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
                directions: model.steps,
                imageName: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                title: model.name
            ) {
                startCooking = false
            }
        }
        .toolbar{
            HStack (spacing:10) {
                Button(action: { }) {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                Button(action: { }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                Button(action: { }) {
                    Image(systemName: "heart")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
            }
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(
            model: RecipeModel(
                name: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                description: "A rich and flavorful salmon recipe featuring brown-buttered tomatoes and basil for a delightful dinner experience.",
                tag1: ["Dinner", "Seafood", "Healthy"],
                tag2: ["Salmon", "Tomato", "Basil", "Gluten-Free"],
                sourceURL: "https://example.com",
                imageURL: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                ratingCount: 105,
                reviewCount: 45,
                rating: 4.7,
                serves: 2,
                subscription: "Pro",
                prepTime: TimeInfo(duration: 10, timeUnit: "minutes"),
                cookTime: TimeInfo(duration: 25, timeUnit: "minutes"),
                mealType: ["Dinner"],
                dishType: "Seafood",
                specialConsideration: ["Gluten-Free"],
                preparationType: ["Baked"],
                ingredientsFilter: ["Fish", "Butter"],
                cuisine: "American",
                difficulty: "Beginner",
                macros: Macros(carbs: 8, protein: 32, fat: 14),
                ingredients: [
                    Ingredient(ingredientName: "Salmon Fillet", ingredientAmount: 2, ingredientUnit: "pieces"),
                    Ingredient(ingredientName: "Cherry Tomatoes", ingredientAmount: 200, ingredientUnit: "g"),
                    Ingredient(ingredientName: "Unsalted Butter", ingredientAmount: 3, ingredientUnit: "tbsp"),
                    Ingredient(ingredientName: "Fresh Basil Leaves", ingredientAmount: 10, ingredientUnit: "pieces")
                ],
                steps: [
                    "Preheat oven to 400°F (200°C).",
                    "Place salmon fillets on a baking sheet.",
                    "In a skillet, melt butter until golden brown. Add tomatoes and sauté until softened.",
                    "Pour the brown-buttered tomatoes over the salmon and bake for 15-20 minutes.",
                    "Garnish with fresh basil leaves and serve warm."
                ],
                calories: 300
            )
        )
        .previewLayout(.device)
    }
}

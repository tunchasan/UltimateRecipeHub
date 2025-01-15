//
//  DirectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct DirectionView: View {
    @ObservedObject var viewModel: SharedViewModel
    var model: RecipeModel
    var scaleFactor: Double = 1.0
    var imageName: String
    var title: String
    var action: () -> Void
    
    @State private var currentStep: Int = 0
    @State private var progress: CGFloat = 0
    @State private var imageHeight: CGFloat = 0.3
    @State private var displayIngredients: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) { // Set alignment for the ZStack
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * imageHeight)
                    .clipped()
                    .opacity(0.2)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * imageHeight)
                    .clipped()
                    .mask(
                        GeometryReader { geometry in
                            Rectangle()
                                .frame(width: geometry.size.width * progress) // Mask width based on progress
                        }
                    )
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
            }
            
            VStack (spacing: 15){
                
                HStack (spacing: 10){
                    
                    Text("Step \(currentStep + 1)/\(model.steps.count)")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    Button(action: {
                        displayIngredients = true
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 20).bold())
                                .foregroundColor(.green)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Text(title)
                    .font(.title.bold())
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 10)
            }
            .padding(.top, 10)
            
            TabView(selection: $currentStep) {
                ForEach(model.steps.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text(model.steps[index])
                            .font(.system(size: 20))
                            .lineSpacing(5)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                            .tag(index) // Bind tab selection to `currentStep`
                    }
                    .padding(.horizontal, 30)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default dots
            .onChange(of: currentStep) { // Update progress
                withAnimation{
                    progress = CGFloat(currentStep) / CGFloat(model.steps.count - 1)
                    
                    if currentStep == model.steps.count - 1 {
                        imageHeight = 0.5
                    }
                    
                    else {
                        imageHeight = 0.3
                    }
                }
            }
            .padding(.bottom, 40)
            
            Spacer()
            
            HStack {
                TextButton(
                    title: currentStep == 0 ? "Close" : "Back",
                    titleColor: .black,
                    titleFontSize: 20
                ) {
                    if currentStep > 0 {
                        withAnimation {
                            progress -= 0.2
                            currentStep -= 1
                            imageHeight = 0.3
                        }
                    }
                    
                    else {
                        action()
                    }
                }
                
                TextButton(
                    title: currentStep == model.steps.count - 1 ? "Done" : "Next",
                    titleColor: .white,
                    titleFontSize: 20
                ) {
                    if currentStep < model.steps.count - 1 {
                        withAnimation {
                            progress += 0.2
                            currentStep += 1
                            imageHeight = 0.3
                        }
                        
                        if currentStep == model.steps.count - 1 {
                            withAnimation {
                                imageHeight = 0.5
                            }
                        }
                    }
                    
                    else {
                        action()
                    }
                }
                .background(.green)
            }
        }
        .sheet(isPresented: $displayIngredients, onDismiss: {
            displayIngredients = false
        }) {
            ScrollView{
                RecipeIngredientsGridView(
                    viewModel: viewModel,
                    ingredients: model.formattedIngredients,
                    servingValue: Double(model.serves),
                    isSliderVisible: viewModel.value != 1.0
                )
                .padding(.top, 20)
                .presentationDetents([.fraction(0.5), .fraction(0.8)]) // Allow dragging between 50% and 70% of screen height
                .presentationDragIndicator(.visible) // Optional: Show a drag indicator
            }
        }
    }
}

struct DirectionView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionView(
            viewModel: SharedViewModel(),
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
                steps: [
                    "Preheat the oven to 375°F (190°C).",
                    "Mix the flour, sugar, and baking powder in a bowl.",
                    "Add eggs and milk, then stir until smooth.",
                    "Pour the batter into a greased baking pan.",
                    "Bake for 25-30 minutes or until golden brown."
                ],
                calories: 200
            ),
            scaleFactor: 1.0,
            imageName: "Haitian Legim", // Replace with a valid image name in your Assets folder
            title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
            action: {
                print("Action triggered!")
            }
        )
        .previewLayout(.sizeThatFits)
    }
}

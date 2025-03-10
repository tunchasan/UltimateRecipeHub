//
//  RecipeDetails.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 7.12.2024.
//

import SwiftUI
import AlertToast

class SharedViewModel: ObservableObject {
    @Published var value: Double = 1.0
}

struct RecipeDetails: View {
    
    var model: ProcessedRecipe
    var canAddToPlan: Bool = true
    var isCookingModeEnable: Bool = true
    var enableImageAnimation: Bool = true
    var shouldManageTabBarVisibility: Bool = false
    var isDirectedFindSuitableRecipes: Bool = false
    var isShoppingToolbarButtonEnabled: Bool = true
    var isDirectoryFromReplaceRecipePage: Bool = false
    var onClickAddToMealPlan: () -> Void = {}
    @State var showWebView: Bool = false

    @State private var isFavorited: Bool = false
    @State private var startCooking: Bool = false
    @State private var addToPlan: Bool = false
    @StateObject private var viewModel = SharedViewModel()
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    
    // Scroll Tracking
    @State private var scrollOffset: CGFloat = 0.6
    @State private var alpha: CGFloat = 0.6 // ⬅️ Dynamic alpha based on offset
    private let maxOffset: CGFloat = 225 // ⬅️ Adjust this for max scrollable area
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (spacing:0) {
            ScrollView {
                GeometryReader { geo in
                    let offset = geo.frame(in: .global).minY // ✅ Get Scroll Offset
                    
                    ZStack {
                        Image(model.recipe.name)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: getDynamicHeight(alpha: alpha) // Adjust height dynamically
                            )
                            .clipped()
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        
                        if isCookingModeEnable {
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
                            .opacity(alpha < 0.25 ? 0 : 1)
                        }
                    }
                    .onAppear {
                        if enableImageAnimation {
                            scrollOffset = offset // ✅ Initialize Offset
                        }
                    }
                    .onChange(of: offset) { oldValue, newValue in
                        if enableImageAnimation {
                            withAnimation(.easeInOut(duration: 0.2)) { // ✅ Smooth Animation
                                scrollOffset = newValue
                                alpha = calculateAlpha(offset: newValue) // ✅ Update alpha
                            }
                        }
                    }
                }
                .frame(height: getDynamicHeight(alpha: alpha)) // Take 40% of screen height
                .padding(.bottom, isCookingModeEnable ? -5 : -15)
                
                VStack(alignment: .leading, spacing: 15) { // Align content to leading
                    Text(model.recipe.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.top, isCookingModeEnable ? 10 : 0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    
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
                    
                    NutritionalInfoView(
                        onClickLockedMacro: {
                            if !isDirectoryFromReplaceRecipePage {
                                PaywallVisibilityManager.show(triggeredBy: .attemptDisplayRecipeMacros)
                            }
                        },
                        macros: model.recipe.macros,
                        calories: model.recipe.calories
                    )
                    
                    Text(model.recipe.description)
                        .font(.system(size: 14))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(.green.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 12)
                }
                .padding(.top, 30)
                .opacity(alpha < 0.25 ? 0 : 1)
                
                RecipeIngredientsGridView(
                    viewModel: viewModel,
                    ingredients: model.recipe.formattedIngredients,
                    servingValue: Double(model.recipe.serves),
                    isPaywallActionable: !isDirectoryFromReplaceRecipePage
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
            
            if canAddToPlan {
                AddToMealPlanFooter(action: {
                    handleAddToPlan()
                })
                .opacity(alpha < 0.25 ? 0 : 1)
            }
        }
        .sheet(isPresented: $addToPlan, onDismiss: {
            addToPlan = false
        }) {
            PlanView(
                isReplaceMode: true
            )
        }
        .sheet(isPresented: $startCooking, onDismiss: {
            startCooking = false
        }) {
            DirectionView(
                viewModel: viewModel,
                model: model.recipe,
                imageName: model.recipe.name,
                title: model.recipe.name
            ) {
                startCooking = false
            }
        }
        .toolbar{
            HStack (spacing:10) {
                
                Button(action: {
                    
                    showWebView = true
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                if isShoppingToolbarButtonEnabled {
                    Button(action: {
                        let result = GroceriesManager.shared.addGroceries(from: model.recipe.ingredients)
                        if result {
                            ToastVisibilityManager.show(for: "Grocery list created!")
                            // Haptic feedback
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }
                        
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .foregroundColor(.green)
                            .font(.system(size: 16))
                    }
                }
                                
                if canAddToPlan {
                    Button(action: {
                        handleAddToPlan()
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.green)
                            .font(.system(size: 16))
                    }
                }
                
                Button(action: {
                    
                    let favoriteManager = FavoriteRecipesManager.shared
                    
                    if !favoriteManager.isFavorited(recipeID: model.id) {
                        
                        isFavorited = favoriteManager.addToFavorites(recipeID: model.id)
                    }
                    
                    else {
                        favoriteManager.removeFromFavorites(recipeID: model.id)
                        
                        isFavorited = false
                    }
                    
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red.opacity(0.85) : .green)
                        .font(.system(size: 16))
                }
            }
        }
        .onAppear {
            isFavorited = FavoriteRecipesManager.shared.isFavorited(recipeID: model.id)
            if shouldManageTabBarVisibility {
                TabVisibilityManager.hideTabBar()
            }
            
            User.shared.increaseRecipeDetailsLookupCount()
        }
        .onDisappear(perform: {
            if shouldManageTabBarVisibility {
                TabVisibilityManager.showTabBar()
            }
        })
        .fullScreenCover(isPresented: $showWebView, onDismiss: { showWebView = false }) {
            if let url = URL(string: model.recipe.sourceURL) {
                SafariView(url: url)
            } else {
                Text("Invalid URL")
            }
        }
    }
    
    private func handleAddToPlan() {
        if isDirectedFindSuitableRecipes {
            if FindRecipesManager.shared.excludeRecipe == nil {
                mealPlanManager.updateRecipe(with: model.id)
                presentationMode.wrappedValue.dismiss()
            }
        }
        else {
            addToPlan = true
            mealPlanManager.onRecieveReplaceRecipe(replaceRecipe: model)
        }
        
        onClickAddToMealPlan()
    }
    
    // MARK: - 📌 Calculate Alpha Based on Scroll Offset
    private func calculateAlpha(offset: CGFloat) -> CGFloat {
        let alphaValue = max(0, min(1, 1 - (offset / maxOffset))) // ⬅️ Keep it between 0 and 1
        return alphaValue
    }
    
    private func getDynamicHeight(alpha: CGFloat) -> CGFloat {
        
        if !enableImageAnimation {
            return UIScreen.main.bounds.height * 0.3
        }
        
        let minHeight: CGFloat = 50  // Minimum height when at the top
        let maxHeight: CGFloat = 550  // Maximum height when scrolled down
        return maxHeight - (maxHeight - minHeight) * alpha // Invert scaling effect
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

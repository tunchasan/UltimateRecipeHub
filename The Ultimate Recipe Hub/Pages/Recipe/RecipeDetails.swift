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
    /// The "Add to grocery list" button beside the Ingredients title (Pro). Off on the recipe comparison screen.
    var isAddToGroceriesButtonVisible: Bool = true
    /// Opened from a grocery item: the page opens at the ingredients with this one highlighted.
    var highlightedIngredient: String? = nil
    /// Opened from the grocery list: no Scale control, the amounts match the list (see `listServings`).
    var isOpenedFromGroceryList: Bool = false
    /// The servings the grocery items were added for: the ingredients open scaled to them, with
    /// a "🛒 6 servings" chip in place of Scale. Nil (items from before 1.3.0): the recipe's own amounts.
    var listServings: Double? = nil
    var onClickAddToMealPlan: () -> Void = {}

    @State private var isFavorited: Bool = false
    @State private var startCooking: Bool = false
    /// The cart's grocery picker: tick the ingredients to buy (1.3.3).
    @State private var isGroceryPickerOpen = false
    @State private var addToPlan: Bool = false
    @StateObject private var viewModel = SharedViewModel()
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    
    // Scroll Tracking
    @State private var alpha: CGFloat = 0.6 // ⬅️ Dynamic alpha based on offset
    /// Like the grocery list's + button: "Add to meal plan" steps out of the way while the page scrolls.
    @State private var isPageScrolling = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let maxOffset: CGFloat = 225 // ⬅️ Adjust this for max scrollable area
    
    @Environment(\.presentationMode) var presentationMode
    
    /// The list's servings as a scale of the recipe's own (6 of 4 servings = 1.5×). Nil: no change.
    private var listScale: Double? {
        guard isOpenedFromGroceryList, let listServings, listServings > 0, model.recipe.serves > 0 else { return nil }
        return listServings / Double(model.recipe.serves)
    }
    
    /// "6 servings", for the chip beside the Ingredients title. Nil when there is nothing to say.
    private var listServingsText: String? {
        guard listScale != nil, let listServings else { return nil }
        let amount = listServings.formatted(.number.precision(.fractionLength(0...2)))
        return listServings == 1 ? "1 serving" : "\(amount) servings"
    }
    private let ingredientsSectionID = "ingredients"
    /// Recipe title: 26 pt, growing with the iPhone text size setting like the built-in title styles.
    @ScaledMetric(relativeTo: .title) private var titleFontSize: CGFloat = 26
    
    var body: some View {
        VStack (spacing:0) {
            ScrollViewReader { proxy in
                ScrollView {
                  // One column exactly as wide as the screen: a row that grows wider (long badges, large text)
                  // can no longer make the page drag sideways. ScrollView stacks its content like this VStack.
                  VStack {
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
                        .onChange(of: offset) { _, newValue in
                            guard enableImageAnimation else { return }
                            // Only when the header's look changes: below the header, scrolling
                            // no longer rebuilds the whole page on every frame
                            let newAlpha = calculateAlpha(offset: newValue)
                            guard newAlpha != alpha else { return }
                            withAnimation(.easeInOut(duration: 0.2)) { // ✅ Smooth Animation
                                alpha = newAlpha
                            }
                        }
                    }
                    .frame(height: getDynamicHeight(alpha: alpha)) // Take 40% of screen height
                    .padding(.bottom, isCookingModeEnable ? -5 : -15)
                
                    VStack(alignment: .leading, spacing: 15) { // Align content to leading
                        Text(model.recipe.name)
                            .font(.system(size: titleFontSize, weight: .bold)) // 26 pt
                            .multilineTextAlignment(.leading)
                            .padding(.top, isCookingModeEnable ? 10 : 0)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 4) // with the 15 pt stack spacing: 19 pt above the badges
                    
                        HStack {
                            infoBadge("👨‍🍳  \(String(model.recipe.difficultyType.rawValue))")
                            infoBadge("🧑  \(String(model.recipe.serves))")
                            infoBadge("🥘  \(String(model.recipe.dishType.capitalizedWords))")
                        }
                        .padding(.horizontal)
                    
                        HStack {
                            infoBadge("🔔  Prep \(String(model.recipe.prepTime.duration)) \(String(model.recipe.prepTime.timeUnit))")
                            infoBadge("🔔  Cook \(String(model.recipe.cookTime.duration)) \(String(model.recipe.cookTime.timeUnit))")
                        }
                        .padding(.horizontal)
                    
                        NutritionalInfoView(
                            onClickLockedMacro: {
                                if !isDirectoryFromReplaceRecipePage {
                                    PaywallVisibilityManager.show(triggeredBy: .attemptDisplayRecipeMacros)
                                }
                            },
                            macros: model.recipe.macros,
                            calories: model.recipe.calories,
                            isFullWidth: true // a band edge to edge, like the servings row
                        )
                    
                        Text(model.recipe.description)
                            .font(.system(size: 16)) // same as the ingredients
                            .lineSpacing(5)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                            // A band edge to edge, like the servings row; the text keeps the title's 20 pt margin
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(.green.opacity(0.1))
                    }
                    .padding(.top, 30)
                    .opacity(alpha < 0.25 ? 0 : 1)
                
                    RecipeIngredientsGridView(
                        viewModel: viewModel,
                        ingredients: model.recipe.formattedIngredients,
                        sourceIngredients: model.recipe.ingredients,
                        servingValue: Double(model.recipe.serves),
                        isScaleVisible: !isOpenedFromGroceryList,
                        isPaywallActionable: !isDirectoryFromReplaceRecipePage,
                        highlightedName: highlightedIngredient,
                        listServingsText: listServingsText,
                        // Pro: "Add to list" next to the title opens the same picker as the top bar's cart
                        onAddToGroceries: isShoppingToolbarButtonEnabled && isAddToGroceriesButtonVisible
                            ? { isGroceryPickerOpen = true } : nil
                    )
                    .padding(.top, 30)
                    .id(ingredientsSectionID)
                
                    DirectionsView(
                        ingredientKeywords: model.recipe.ingredients.extractIngredientNames(),
                        directions: model.recipe.steps
                    )
                    .padding(.top, 20)
                
                    RecipeTagGridView(tags: model.recipe.combinedTags)
                        .padding(.top, 20)
                  }
                  .containerRelativeFrame(.horizontal)
                }
                .scrollIndicators(.hidden)
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                .modifier(TrackScrolling(isScrolling: $isPageScrolling))
                // Over the bottom of the page, so hiding it while scrolling leaves no empty band;
                // the page keeps room for it, so the last lines still scroll clear of it.
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if canAddToPlan {
                        let isHidden = alpha < 0.25 || isPageScrolling
                        AddToMealPlanFooter(style: mealPlanFooterStyle, action: {
                            handleAddToPlan()
                        })
                        // The footer's grey is see-through: white under it, down to the screen's bottom edge
                        .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
                        .opacity(isHidden ? 0 : 1)
                        .offset(y: isHidden && !reduceMotion ? 20 : 0)
                        .animation(.easeInOut(duration: isHidden ? 0.2 : 0.35), value: isHidden)
                        .allowsHitTesting(!isHidden)
                    }
                }
                .onAppear {
                    // Coming from a grocery item: once the page is laid out, bring that ingredient
                    // to the middle of the screen (or the ingredients, if its name was edited).
                    guard let highlightedIngredient else { return }
                    let isInRecipe = model.recipe.formattedIngredients.contains {
                        RecipeIngredientsGridView.isSameIngredient($0.2, highlightedIngredient)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            if isInRecipe {
                                proxy.scrollTo(RecipeIngredientsGridView.highlightedRowID, anchor: .center)
                            } else {
                                proxy.scrollTo(ingredientsSectionID, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $addToPlan, onDismiss: {
            addToPlan = false
        }) {
            PlanView(
                isReplaceMode: true
            )
        }
        .sheet(isPresented: $isGroceryPickerOpen) {
            // Opens at the servings the page shows (the servings stepper).
            GroceryPickerSheet(recipe: model, pageScale: viewModel.value) { count, isUpdate in
                RatingPromptManager.shared.recipeSentToGroceries(recipeID: model.id)
                ToastVisibilityManager.show(for: isUpdate ? "Grocery list updated"
                    : (count == 1 ? "1 item added to your list" : "\(count) items added to your list"))
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
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
                
                if isShoppingToolbarButtonEnabled {
                    Button(action: {
                        // Recipe to list stays Pro: free users get the paywall, as before the picker.
                        if User.shared.subscription == .free {
                            PaywallVisibilityManager.show(triggeredBy: .attemptToAddIngredientsToGroceries)
                        } else {
                            isGroceryPickerOpen = true
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
            // From the grocery list: show the amounts for the servings the items were added for.
            if let listScale { viewModel.value = listScale }
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
            RatingPromptManager.shared.pause(.leftRecipe)
        })
    }
    
    /// Info badge under the title: "👨‍🍳  Beginner", "🔔  Prep 15 minutes".
    private func infoBadge(_ text: LocalizedStringKey) -> some View {
        Text(text)
            .font(.callout.bold()) // 16 pt
            .foregroundColor(.green)
            .lineLimit(1)
            .minimumScaleFactor(0.8) // on a narrow iPhone, shrinks a little instead of breaking onto two lines
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(.gray.opacity(0.1))
            .cornerRadius(12)
    }
    
    /// "Use this recipe" when it replaces a planned meal; "In your plan: Tuesday dinner" when this week's
    /// plan already has it; otherwise "Add to meal plan".
    private var mealPlanFooterStyle: AddToMealPlanFooter.Style {
        if isDirectedFindSuitableRecipes { return .use }
        let planned = mealPlanManager.plannedSlots(forRecipeID: model.id)
        guard let first = planned.first else { return .add }
        let more = planned.count > 1 ? " and \(planned.count - 1) more" : "" // "Tuesday dinner and 1 more"
        return .planned(MealPlanManager.slotPhrase(date: first.date, slot: first.slot) + more)
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

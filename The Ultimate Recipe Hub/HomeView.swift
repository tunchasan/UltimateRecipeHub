//
//  HomePage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.12.2024.
//

import SwiftUI
import Foundation

class HomeSelectionManager: ObservableObject {
    static let shared = HomeSelectionManager()
    @Published var selectedTab: Tab = .recipes
}

struct HomeView: View {
    @StateObject private var user = User.shared
    @StateObject private var selectionManager = HomeSelectionManager.shared
    
    var body: some View {
        TabView(selection: $selectionManager.selectedTab) {
            Tab.plan.view
                .tabItem {
                    Label(Tab.plan.title, systemImage: Tab.plan.icon)
                }
                .tag(Tab.plan)
                .badge(1)
            
            Tab.recipes.view
                .tabItem {
                    Label(Tab.recipes.title, systemImage: Tab.recipes.icon)
                }
                .tag(Tab.recipes)
                .badge(1)
            
            Tab.favorites.view
                .tabItem {
                    Label(Tab.favorites.title, systemImage: Tab.favorites.icon)
                }
                .tag(Tab.favorites)
            
            Tab.groceries.view
                .tabItem {
                    Label(Tab.groceries.title, systemImage: Tab.groceries.icon)
                }
                .tag(Tab.groceries)
            
            Tab.settings.view
                .tabItem {
                    Label(Tab.settings.title, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .accentColor(.green.opacity(0.8))
        .onAppear {
            user.setOnboardingAsComplete()
        }
    }
}

enum Tab: Hashable {
    case plan
    case recipes
    case favorites
    case groceries
    case settings
    
    var title: String {
        switch self {
        case .plan: return "Plan"
        case .recipes: return "Recipes"
        case .favorites: return "Favorites"
        case .groceries: return "Groceries"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .plan: return "calendar"
        case .recipes: return "book"
        case .favorites: return "heart"
        case .groceries: return "cart"
        case .settings: return "gearshape"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .plan: PlanView()
        case .recipes: RecipesView()
        case .favorites: FavoritesView()
        case .groceries: GroceriesView()
        case .settings: SettingsView()
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 30){
                    HStack(spacing: 20) {
                        RecipeCard(
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
                        )
                        
                        RecipeCard(
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
                        )
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(
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
                        )
                        
                        RecipeCard(
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
                        )
                    }
                }
                .padding(.top, 25)
                .padding(.bottom, 10)
                .padding(.horizontal, 15)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Favorites")
        }
    }
}

struct GroceriesView: View {
    let ingredients = [
        ("1 large", "Butternut squash"),
        ("4 tablespoons", "Extra-virgin olive oil"),
        ("", "Kosher salt and pepper"),
        ("1 pinch", "Cayenne pepper"),
        ("1/4 teaspoon", "Ground nutmeg"),
        ("1", "Red onion"),
        ("1/2 pound", "Orecchiette"),
        ("1 or 2", "Garlic cloves"),
        ("2 cups", "Chicken broth"),
        ("1 bunch", "Kale"),
        ("1/2 cup", "White wine"),
        ("1/2 cup", "Heavy cream"),
        ("1 ounce", "Goat cheese (optional)"),
        ("1 tablespoon", "Fresh sage"),
        ("", "Parmesan cheese, to serve")
    ]
    
    @State private var checkedItems: [Int: Bool] = [:] // Tracks the checked state of each ingredient
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: -5) {
                        // Sort ingredients based on their checked status
                        let sortedIngredients = ingredients.enumerated().sorted {
                            !(checkedItems[$0.offset] ?? false) && (checkedItems[$1.offset] ?? false)
                        }
                        
                        ForEach(sortedIngredients, id: \.offset) { index, ingredient in
                            let (quantity, name) = ingredient
                            
                            HStack(spacing: 10) {
                                Button(action: {
                                    checkedItems[index] = !(checkedItems[index] ?? false)
                                }) {
                                    Image(systemName: checkedItems[index] == true ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(checkedItems[index] == true ? .green : .gray)
                                }
                                
                                if !quantity.isEmpty {
                                    Text(quantity)
                                        .font(.system(size: 16).bold())
                                        .foregroundColor(.green)
                                        .strikethrough(checkedItems[index] == true, color: .gray)
                                }
                                
                                Text(name)
                                    .font(.system(size: 16))
                                    .foregroundColor(checkedItems[index] == true ? .gray : .black)
                                    .strikethrough(checkedItems[index] == true, color: .gray)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, minHeight: 30, alignment: .center)
                            .onAppear {
                                if checkedItems[index] == nil {
                                    checkedItems[index] = false
                                }
                            }
                        }
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 10)
                }
                .padding(.bottom, 20)
                .toolbar {
                    Button(action: {
                        checkedItems = [:] // Clear all checked items
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(size: 16).bold())
                    }
                }
                .navigationTitle("Groceries")
            }
        }
    }
}

struct GroceriesMenuButton: View {
    var systemImageName: String
    var systemImageColor: Color = .green
    var size: CGFloat = 30
    
    var body: some View {
        Menu {
            Button(role: .destructive) {
                print("Clear")
            } label: {
                Label("Clear", systemImage: "trash")
            }
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.5).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

struct GroceriesView_Previews: PreviewProvider {
    static var previews: some View {
        GroceriesView()
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings Page")
                    .font(.title)
            }
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        GroceriesView()
    }
}

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

struct RecipesView: View {
    
    @State var isButtonSelectable: Bool = true
    @StateObject private var selectionManager = HomeSelectionManager.shared
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    CollectionView()
                    
                    RecommendedPlanCardView(imageUrl: "Background2", action: {
                        selectionManager.selectedTab = .plan
                    })
                    
                    SaveExternalSourceCardView(
                        imageUrl: "Test1",
                        content: "Add your favorite recipes \nfrom the web",
                        destination: SavedRecipesView())
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        Text("Popular")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 20) {
                            RichButton(title: "Easy Dinner", emoji: "🍽️", action: {
                                print("Easy Dinner tapped")
                            })
                            RichButton(title: "One Pot", emoji: "🍲", action: {
                                print("One Pot tapped")
                            })
                        }
                        
                        HStack(spacing: 20) {
                            RichButton(title: "Pasta", emoji: "🍝", action: {
                                print("Pasta Paradise tapped")
                            })
                            RichButton(title: "Desserts", emoji: "🍰", action: {
                                print("Desserts tapped")
                            })
                        }
                        
                        HStack(spacing: 20) {
                            RichButton(title: "Italian", emoji: "🍕", action: {
                                print("Italian tapped")
                            })
                            RichButton(title: "Soups", emoji: "🥣", action: {
                                print("Soups tapped")
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                    
                    SaveExternalSourceCardView(
                        imageUrl: "Background2",
                        content: "Add your favorite restaurants \nfrom the web",
                        destination: SavedRestaurantsView())
                    .padding(.bottom, 30)
                    
                    CollectionView()
                    CollectionView()
                    CollectionView()
                    CollectionView()
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Recipes")
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 30){
                    HStack(spacing: 20) {
                        RecipeCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans",
                                   imageUrl: "Baked Salmon With Brown-Buttered Tomatoes & Basil", showProBadge: false, showFavoriteButton: true, action: {})
                        
                        RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                   imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette", showProBadge: false, showFavoriteButton: true, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Haitian Legim",
                                   imageUrl: "Haitian Legim", showFavoriteButton: true, action: {})
                        
                        RecipeCard(title: "Duck Breast With Blueberry-Port Sauce",
                                   imageUrl: "Duck Breast With Blueberry-Port Sauce", showProBadge: false, showFavoriteButton: true, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Paneer and Cauliflower Makhani",
                                   imageUrl: "Paneer and Cauliflower Makhani", showProBadge: false, showFavoriteButton: true, action: {})
                        
                        RecipeCard(title: "Peruvian Chicken & Basil Pasta (Sopa Seca)",
                                   imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)", showProBadge: false, showFavoriteButton: true, action: {})
                    }
                    HStack(spacing: 20) {
                        RecipeCard(title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
                                   imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", showProBadge: false, showFavoriteButton: true, action: {})
                        
                        RecipeCard(title: "No-Noodle Eggplant Lasagna with Mushroom Ragú",
                                   imageUrl: "No-Noodle Eggplant Lasagna with Mushroom Ragú", showProBadge: false, showFavoriteButton: true, action: {})
                    }
                    HStack(spacing: 20) {
                        RecipeCard(title: "Toasted Farro & Antipasto Salad",
                                   imageUrl: "Toasted Farro & Antipasto Salad", showProBadge: false, showFavoriteButton: true, action: {})
                        
                        RecipeCard(title: "Beet-Chickpea Cakes With Tzatziki",
                                   imageUrl: "Beet-Chickpea Cakes With Tzatziki", showProBadge: false, showFavoriteButton: true, action: {})
                    }
                }
                .padding(.top, 25)
                .padding(.horizontal, 15)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Favorites")
        }
    }
}

struct CollectionDetailsView: View {
    var body: some View {
        VStack{
            Text("Most Popular Recipts")
                .font(.title2.bold())
                .padding(.top, 30)
            
            ScrollView{
                VStack(spacing: 50){
                    HStack(spacing: 20) {
                        RecipeCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans",
                                   imageUrl: "1",
                                   showProBadge: true,
                                   action: {
                        })
                        
                        RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                   imageUrl: "2", showProBadge: false, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Patricia Wells' Zucchini Carpaccio With Avocado & Pistachios",
                                   imageUrl: "3", action: {})
                        
                        RecipeCard(title: "Juicy Pork Tenderloin With Cider-Glazed Red Cabbage",
                                   imageUrl: "1", showProBadge: true ,action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Mushroom Ginger Soup with Hulled Barley",
                                   imageUrl: "1", showProBadge: true ,action: {})
                        
                        RecipeCard(title: "Ground Meat Ragu (The Butcher's Ragu)",
                                   imageUrl: "2", showProBadge: true, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans",
                                   imageUrl: "1", showProBadge: true, action: {})
                        
                        RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                   imageUrl: "2", showProBadge: false, action: {})
                    }
                    HStack(spacing: 20) {
                        RecipeCard(title: "Patricia Wells' Zucchini Carpaccio With Avocado & Pistachios",
                                   imageUrl: "3", action: {})
                        
                        RecipeCard(title: "Juicy Pork Tenderloin With Cider-Glazed Red Cabbage",
                                   imageUrl: "1", showProBadge: true ,action: {})
                    }
                }
                .padding(.top, 30)
            }
            .scrollIndicators(.hidden)
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

//
//  HomePage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.12.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var user = User.shared
    @State private var selectedTab: Tab = .recipes
    
    var body: some View {
        TabView(selection: $selectedTab) {
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

struct PlanView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                
                Text("Today")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                
                HStack {
                    TextButton(
                        title: "2340",
                        subTitle: "Calories",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    
                    TextButton(
                        title: "50gr",
                        subTitle: "Protein",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    TextButton(
                        title: "200gr",
                        subTitle: "Carb",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    TextButton(
                        title: "120gr",
                        subTitle: "Fat",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                }
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .shadow(radius: 3, x:1, y:2)
                
                VStack(spacing: 50) {
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", recipeTypeTitle: "Breakfast",
                                       imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", difficulty: 2, action: {})
                        
                        RecipePlanCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette", recipeTypeTitle: "Breakfast",
                                       imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette", difficulty: 3, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Paneer and Cauliflower Makhani", recipeTypeTitle: "Lunch",
                                       imageUrl: "Paneer and Cauliflower Makhani", difficulty: 2, action: {})
                        
                        RecipePlanCard(title: "Beet-Chickpea Cakes With Tzatziki", recipeTypeTitle: "Lunch",
                                       imageUrl: "Beet-Chickpea Cakes With Tzatziki", difficulty: 3, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Haitian Legim", recipeTypeTitle: "Dinner",
                                       imageUrl: "Haitian Legim", difficulty: 2, action: {})
                        
                        RecipePlanCard(title: "Peruvian Chicken & Basil Pasta (Sopa Seca)", recipeTypeTitle: "Dinner",
                                       imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)", difficulty: 3, action: {})
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 25)
                
                Text("Tomorrow")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 30)
                    .padding(.bottom, 10)

                HStack {
                    TextButton(
                        title: "1830",
                        subTitle: "Calories",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    
                    TextButton(
                        title: "40gr",
                        subTitle: "Protein",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    TextButton(
                        title: "140gr",
                        subTitle: "Carb",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    TextButton(
                        title: "90gr",
                        subTitle: "Fat",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                }
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .shadow(radius: 3, x:1, y:2)
                
                VStack(spacing: 50) {
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", recipeTypeTitle: "Breakfast",
                                       imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", difficulty: 2, isEatenButtonVisible: false, action: {})
                        
                        RecipePlanCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette", recipeTypeTitle: "Breakfast",
                                       imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette", difficulty: 3, isEatenButtonVisible: false, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Paneer and Cauliflower Makhani", recipeTypeTitle: "Lunch",
                                       imageUrl: "Paneer and Cauliflower Makhani", difficulty: 2, isEatenButtonVisible: false, action: {})
                        
                        RecipePlanCard(title: "Beet-Chickpea Cakes With Tzatziki", recipeTypeTitle: "Lunch",
                                       imageUrl: "Beet-Chickpea Cakes With Tzatziki", difficulty: 3, isEatenButtonVisible: false, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Haitian Legim", recipeTypeTitle: "Dinner",
                                       imageUrl: "Haitian Legim", difficulty: 2, isEatenButtonVisible: false, action: {})
                        
                        RecipePlanCard(title: "Peruvian Chicken & Basil Pasta (Sopa Seca)", recipeTypeTitle: "Dinner",
                                       imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)", difficulty: 3, isEatenButtonVisible: false, action: {})
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 25)
                
                Text("December 13")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 30)
                    .padding(.bottom, 10)

                HStack {
                    TextButton(
                        title: "1830",
                        subTitle: "Calories",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    
                    TextButton(
                        title: "40gr",
                        subTitle: "Protein",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    TextButton(
                        title: "140gr",
                        subTitle: "Carb",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                    TextButton(
                        title: "90gr",
                        subTitle: "Fat",
                        titleColor: .green,
                        titleFontSize: 20,
                        action: {
                            print("Favorites tapped")
                        }
                    )
                }
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .shadow(radius: 3, x:1, y:2)
                
                VStack(spacing: 50) {
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", recipeTypeTitle: "Breakfast",
                                       imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", difficulty: 2, isEatenButtonVisible: false, action: {})
                        
                        RecipePlanCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette", recipeTypeTitle: "Breakfast",
                                       imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette", difficulty: 3, isEatenButtonVisible: false, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Paneer and Cauliflower Makhani", recipeTypeTitle: "Lunch",
                                       imageUrl: "Paneer and Cauliflower Makhani", difficulty: 2, isEatenButtonVisible: false, action: {})
                        
                        RecipePlanCard(title: "Beet-Chickpea Cakes With Tzatziki", recipeTypeTitle: "Lunch",
                                       imageUrl: "Beet-Chickpea Cakes With Tzatziki", difficulty: 3, isEatenButtonVisible: false, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipePlanCard(title: "Haitian Legim", recipeTypeTitle: "Dinner",
                                       imageUrl: "Haitian Legim", difficulty: 2, isEatenButtonVisible: false, action: {})
                        
                        RecipePlanCard(title: "Peruvian Chicken & Basil Pasta (Sopa Seca)", recipeTypeTitle: "Dinner",
                                       imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)", difficulty: 3, isEatenButtonVisible: false, action: {})
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 25)
                .padding(.bottom, 40)
            }
            .navigationTitle("Meal Plan")
        }
    }
}

struct RecipesView: View {
    var body: some View {
        @State var isButtonSelectable: Bool = true
        
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    CollectionView()
                    RecommendedPlanCardView(imageUrl: "Background2", action: {})
                    
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
                    .padding(.bottom, 25)
                    .padding(.top, 15)
                    
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
                VStack(spacing: 40){
                    HStack(spacing: 20) {
                        RecipeCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans",
                                   imageUrl: "Baked Salmon With Brown-Buttered Tomatoes & Basil", showProBadge: true, difficulty: 2, action: {})
                        
                        RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                   imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette", showProBadge: false, difficulty: 3, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Haitian Legim",
                                   imageUrl: "Haitian Legim", action: {})
                        
                        RecipeCard(title: "Duck Breast With Blueberry-Port Sauce",
                                   imageUrl: "Duck Breast With Blueberry-Port Sauce", showProBadge: true ,action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Paneer and Cauliflower Makhani",
                                   imageUrl: "Paneer and Cauliflower Makhani", showProBadge: true ,action: {})
                        
                        RecipeCard(title: "Peruvian Chicken & Basil Pasta (Sopa Seca)",
                                   imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)", showProBadge: true, difficulty: 1, action: {})
                    }
                    HStack(spacing: 20) {
                        RecipeCard(title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
                                   imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic", showProBadge: true ,action: {})
                        
                        RecipeCard(title: "No-Noodle Eggplant Lasagna with Mushroom Ragú",
                                   imageUrl: "No-Noodle Eggplant Lasagna with Mushroom Ragú", showProBadge: true, difficulty: 1, action: {})
                    }
                    HStack(spacing: 20) {
                        RecipeCard(title: "Toasted Farro & Antipasto Salad",
                                   imageUrl: "Toasted Farro & Antipasto Salad", showProBadge: true ,action: {})
                        
                        RecipeCard(title: "Beet-Chickpea Cakes With Tzatziki",
                                   imageUrl: "Beet-Chickpea Cakes With Tzatziki", showProBadge: true, difficulty: 1, action: {})
                    }
                }
                .padding(.top, 30)
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
                                   imageUrl: "1", showProBadge: true, difficulty: 2, action: {})
                        
                        RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                   imageUrl: "2", showProBadge: false, difficulty: 3, action: {})
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
                                   imageUrl: "2", showProBadge: true, difficulty: 1, action: {})
                    }
                    
                    HStack(spacing: 20) {
                        RecipeCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans",
                                   imageUrl: "1", showProBadge: true, difficulty: 2, action: {})
                        
                        RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                   imageUrl: "2", showProBadge: false, difficulty: 3, action: {})
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
    var body: some View {
        NavigationView {
            VStack {
                Text("Groceries Page")
                    .font(.title)
            }
        }
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
        PlanView()
    }
}

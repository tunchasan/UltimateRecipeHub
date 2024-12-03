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

// Placeholder Views for Tabs
struct PlanView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Plan Page")
                    .font(.title)
            }
        }
    }
}

struct RecipesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Recipes Page")
                    .font(.title)
            }
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                
                HStack(spacing: 20) {
                    RecipeCard(title: "Green Vegetables Lasagna with Zucchini, Peas, and Green Beans",
                        imageUrl: "1", showProBadge: true, difficulty: 2, action: {})

                    RecipeCard(title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                        imageUrl: "2", showProBadge: false, difficulty: 3, action: {})
                }
                .padding(.vertical, 20)
                
                HStack(spacing: 20) {
                    RecipeCard(title: "Patricia Wells' Zucchini Carpaccio With Avocado & Pistachios",
                        imageUrl: "3", action: {})
                    
                    RecipeCard(title: "Juicy Pork Tenderloin With Cider-Glazed Red Cabbage",
                        imageUrl: "1", showProBadge: true ,action: {})
                }
                .padding(.vertical, 20)

                HStack(spacing: 20) {
                    RecipeCard(title: "Mushroom Ginger Soup with Hulled Barley",
                        imageUrl: "1", showProBadge: true ,action: {})

                    RecipeCard(title: "Ground Meat Ragu (The Butcher's Ragu)",
                        imageUrl: "2", showProBadge: true, difficulty: 1, action: {})
                }
                .padding(.vertical, 20)
            }
            .padding(.top, 20)
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
        HomeView()
    }
}

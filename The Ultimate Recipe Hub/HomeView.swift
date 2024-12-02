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
                
                HStack(spacing: 60) {
                    RecipeCard(imageUrl: "https://images.food52.com/a7gj5nkQN9V8r7CcAu9me820qZY=/2016x1344/filters:format(webp)/fa4a2c19-ec5b-4b2b-a29d-3feb3850325c--2018-0712_summer-farro-salad_3x2_rocky-luten_021.jpg", action: {})
                    
                    RecipeCard(imageUrl: "https://images.food52.com/-PTeJELxHtgww5J45SBXfdt846w=/1008x672/filters:format(webp)/951a581c-d05a-4972-b90e-119fe3b8b478--09070f52_ME_0215.JPG", action: {})
                }
                .padding(20)
                .padding(.top, 20)
                
                HStack(spacing: 60) {
                    RecipeCard(imageUrl: "https://images.food52.com/48V7TvnaiiTOzsXrnmzHK_JZeh4=/2016x1344/filters:format(webp)/f888cdbd-392f-4918-8c9b-5e17c3dde64d--2018-0717_lacinato-kale-and-mint-salad-reshoot_3x2_rocky-luten_021.jpg", action: {})
                    
                    RecipeCard(imageUrl: "https://images.food52.com/SDxNgLm9e_ry6QY1vynrd1nzUi4=/2016x1344/filters:format(webp)/a4c5df50-5a72-428f-a7df-418fe897ebd0--020910F_0646.JPG", action: {})
                }
                .padding(20)

                HStack(spacing: 60) {
                    RecipeCard(imageUrl: "https://images.food52.com/CypYNlOHdvYt7fsnRufA7XgOhrM=/2016x1344/filters:format(webp)/ccdd5d08-31d2-4b64-8ba0-48ed3efe6e40--2016-0119_boiled-chicken-with-ginger_bobbi-lin_17130.jpg", action: {})
                    
                    RecipeCard(imageUrl: "https://images.food52.com/Oge2-UZNc3AwELw0r1DX1gAVuEc=/2016x1344/filters:format(webp)/497fb4ba-6bad-4231-ad55-78b43b1ccca9--2022-0310_unadon-eel-rice-bowl-final_3x2_julia-gartland.jpg", action: {})
                }
                .padding(20)

                HStack(spacing: 60) {
                    RecipeCard(imageUrl: "https://images.food52.com/a7gj5nkQN9V8r7CcAu9me820qZY=/2016x1344/filters:format(webp)/fa4a2c19-ec5b-4b2b-a29d-3feb3850325c--2018-0712_summer-farro-salad_3x2_rocky-luten_021.jpg", action: {})
                    
                    RecipeCard(imageUrl: "https://images.food52.com/F0k5ygiPSjJ8HbQKw7qxMsK8ZCg=/2016x1344/filters:format(webp)/019850f4-4c45-4191-a62d-4fb6b00e6599--lemon-chicken_food52_mark_weinberg_14-11-21_0198.jpg", action: {})
                }
                .padding(20)

                HStack(spacing: 60) {
                    RecipeCard(imageUrl: "https://images.food52.com/a7gj5nkQN9V8r7CcAu9me820qZY=/2016x1344/filters:format(webp)/fa4a2c19-ec5b-4b2b-a29d-3feb3850325c--2018-0712_summer-farro-salad_3x2_rocky-luten_021.jpg", action: {})
                    
                    RecipeCard(imageUrl: "https://images.food52.com/-PTeJELxHtgww5J45SBXfdt846w=/1008x672/filters:format(webp)/951a581c-d05a-4972-b90e-119fe3b8b478--09070f52_ME_0215.JPG", action: {})
                }
            }
            .padding(.top, 20)
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

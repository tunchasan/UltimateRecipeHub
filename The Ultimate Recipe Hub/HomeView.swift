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

            Tab.recipes.view
                .tabItem {
                    Label(Tab.recipes.title, systemImage: Tab.recipes.icon)
                }
                .tag(Tab.recipes)

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
            .navigationTitle("Meal Plan")
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
            .navigationTitle("Recipes")
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites Page")
                    .font(.title)
            }
            .navigationTitle("Favorites")
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
            .navigationTitle("Groceries")
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
            .navigationTitle("Settings")
        }
    }
}


struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

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
    @Published var selectedTab: Tab = .plan
    @Published var navigateToSavedRecipes = false
    @Published var navigateToSavedRestaurants = false

    func triggerNavigateToSavedRecipes() {
        DispatchQueue.main.async {
            self.navigateToSavedRecipes = true
        }
    }

    func triggerNavigateToSavedRestaurants() {
        DispatchQueue.main.async {
            self.navigateToSavedRestaurants = true
        }
    }
}

class LoadingVisibilityManager: ObservableObject {
    static let shared = LoadingVisibilityManager()
    @Published var isVisible = false

    private init() {} // Prevents external instantiation

    /// Hides the tab bar with animation
    static func hideLoading() {
        if shared.isVisible {
            shared.isVisible = false
        }
    }

    /// Shows the tab bar with animation
    static func showLoading() {
        if !shared.isVisible {
            DispatchQueue.main.async {
                withAnimation {
                    shared.isVisible = true
                }
            }
        }
    }
}

class PaywallVisibilityManager: ObservableObject {
    
    static let shared = PaywallVisibilityManager()
    
    @Published var isVisible = false
    @Published var triggerSource: PaywallTrigger = .attemptUnknown

    private init() {} // Prevents external instantiation

    /// Enum to track what triggered the paywall
    public enum PaywallTrigger {
        case attemptUnknown
        case attemptGenerateWeeklyPlan
        case attemptGenerateNextDayPlan
        case attemptWaterChallengeUsage
        case attemptGenerateTodayPlanOnceAgain
        case attemptDisplayDayPlanMacros
        case attemptDisplayRecipeMacros
        case attemptAddRecipeToFavoritesOver3
        case attemptAddExternalRecipeOver1
        case attemptAddExternalRestaurantOver1
        case attemptToSeeProRecipeDetails
        case attemptToScaleRecipeIngredients
        case attemptToSwapWithAICoach
        case attemptToAddIngredientsToGroceries
    }

    /// Hides the paywall
    static func hide() {
        if shared.isVisible {
            shared.isVisible = false
            shared.triggerSource = .attemptUnknown
        }
    }

    /// Shows the paywall and tracks what triggered it
    static func show(triggeredBy source: PaywallTrigger) {
        if !shared.isVisible {
            DispatchQueue.main.async {
                withAnimation {
                    shared.isVisible = true
                    shared.triggerSource = source // Store trigger source
                }
            }
        }
    }
}

class TabVisibilityManager: ObservableObject {
    static let shared = TabVisibilityManager()

    @Published var isVisible: Bool = true

    private init() {} // Prevents external instantiation

    /// Hides the tab bar with animation
    static func hideTabBar() {
        if shared.isVisible {
            shared.isVisible = false
        }
    }

    /// Shows the tab bar with animation
    static func showTabBar() {
        if !shared.isVisible {
            DispatchQueue.main.async {
                withAnimation {
                    shared.isVisible = true
                }
            }
        }
    }
}

struct HomeView: View {
    @StateObject private var user = User.shared
    @StateObject private var selectionManager = HomeSelectionManager.shared
    @ObservedObject private var planManager = MealPlanManager.shared
    @ObservedObject var groceriesManager = GroceriesManager.shared
    @ObservedObject var favoriManager = FavoriteRecipesManager.shared

    var body: some View {
        TabView(selection: $selectionManager.selectedTab) {
            Tab.plan.view
                .tabItem {
                    Label(Tab.plan.title, systemImage: Tab.plan.icon)
                }
                .tag(Tab.plan)
                .badge(planManager.updatesCount)

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
                .badge(favoriManager.favoritesCount)
            
            Tab.groceries.view
                .tabItem {
                    Label(Tab.groceries.title, systemImage: Tab.groceries.icon)
                }
                .tag(Tab.groceries)
                .badge(groceriesManager.uncheckedItemCount())
            
            /*Tab.settings.view
                .tabItem {
                    Label(Tab.settings.title, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)*/
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
        case .settings: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .plan: return "calendar"
        case .recipes: return "book"
        case .favorites: return "heart"
        case .groceries: return "cart"
        case .settings: return "person.crop.circle"
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

struct SettingsView: View {
    @ObservedObject private var user = User.shared
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()

                RoundedButton(
                    title: user.subscription == .pro ? "Switch to Free" : "Switch to Pro",
                    backgroundColor: .purple
                ) {
                    if user.subscription == .pro {
                        user.subscription = .free
                    }
                    
                    else {
                        user.subscription = .pro
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  User 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import SwiftUI

class ExternalSourceManager: ObservableObject {
    
    static let shared = ExternalSourceManager()
    
    private let savedRecipesKey = "SavedRecipes"
    private let savedRestaurantsKey = "SavedRestaurants"
    
    @Published var SavedRecipes: [ExternalSource] = []
    @Published var SavedRestaurants: [ExternalSource] = []

    init() {
        loadSavedRecipes()
        loadSavedRestaurants()
    }
    
    public func isRecipeExist(url: String) -> Bool {
        return SavedRecipes.contains(where: { $0.url == url })
    }
    
    public func isRestaurantExist(url: String) -> Bool {
        return SavedRestaurants.contains(where: { $0.url == url })
    }
    
    func addRecipe(url: String) -> Bool {
        guard !SavedRecipes.contains(where: { $0.url == url }) else {
            print("Recipe already exists")
            return false
        }
        
        if SavedRecipes.count >= 1 && User.shared.subscription == .free {
            PaywallVisibilityManager.show(triggeredBy: .attemptAddExternalRecipeOver1)
            return false
        }
        
        RateUsPrePromptVisibilityManager.show(after: 2)

        let newRecipe = ExternalSource(url: url)
        SavedRecipes.append(newRecipe)
        saveSavedRecipes()
        return true
    }
    
    func addRestaurant(url: String) -> Bool {
        guard !SavedRestaurants.contains(where: { $0.url == url }) else {
            print("Restaurant already exists")
            return false
        }
        
        if SavedRestaurants.count >= 1 && User.shared.subscription == .free {
            PaywallVisibilityManager.show(triggeredBy: .attemptAddExternalRestaurantOver1)
            return false
        }
        
        RateUsPrePromptVisibilityManager.show(after: 2)

        let newRestaurant = ExternalSource(url: url)
        SavedRestaurants.append(newRestaurant)
        saveSavedRestaurants()
        return true
    }
    
    func removeRecipe(id: UUID) {
        SavedRecipes.removeAll { $0.id == id }
        saveSavedRecipes()
    }
    
    func removeRestaurant(id: UUID) {
        SavedRestaurants.removeAll { $0.id == id }
        saveSavedRestaurants()
    }
    
    private func saveSavedRecipes() {
        let data = SavedRecipes.map { ["id": $0.id.uuidString, "url": $0.url] }
        UserDefaults.standard.set(data, forKey: savedRecipesKey)
    }
    
    private func saveSavedRestaurants() {
        let data = SavedRestaurants.map { ["id": $0.id.uuidString, "url": $0.url] }
        UserDefaults.standard.set(data, forKey: savedRestaurantsKey)
    }
    
    private func loadSavedRecipes() {
        guard let recipesData = UserDefaults.standard.array(forKey: savedRecipesKey) as? [[String: String]] else { return }
        SavedRecipes = recipesData.compactMap { data in
            if let idString = data["id"], let uuid = UUID(uuidString: idString), let url = data["url"] {
                return ExternalSource(id: uuid, url: url)
            }
            return nil
        }
    }
    
    private func loadSavedRestaurants() {
        guard let restaurantsData = UserDefaults.standard.array(forKey: savedRestaurantsKey) as? [[String: String]] else { return }
        SavedRestaurants = restaurantsData.compactMap { data in
            if let idString = data["id"], let uuid = UUID(uuidString: idString), let url = data["url"] {
                return ExternalSource(id: uuid, url: url)
            }
            return nil
        }
    }
}

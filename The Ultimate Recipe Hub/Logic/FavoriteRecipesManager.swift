//
//  FavoriteRecipesManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 12.01.2025.
//

import Combine
import Foundation

class FavoriteRecipesManager: ObservableObject {
    
    // Singleton instance
    static let shared = FavoriteRecipesManager()
    
    // Published property to notify observers about changes
    @Published private(set) var favoritedRecipeIDs: Set<String> = []
    
    // Key used to store and retrieve data from UserDefaults
    private let userDefaultsKey = "FavoritedRecipeIDs"
    private let counterKey = "FavoritedRecipeCount"
    
    // Published property for the favorites counter
    @Published private(set) var favoritesCount: Int = 0

    init() {
        loadFavoritedRecipes()
        loadFavoritesCount()
    }

    /// Adds a recipe ID to the favorites.
    /// - Parameter id: The ID of the recipe to add.
    func addToFavorites(recipeID: String) {
        guard !favoritedRecipeIDs.contains(recipeID) else { return }
        
        favoritedRecipeIDs.insert(recipeID)
        incrementFavoritesCount()
        saveFavoritedRecipes()
    }

    /// Removes a recipe ID from the favorites.
    /// - Parameter id: The ID of the recipe to remove.
    func removeFromFavorites(recipeID: String) {
        favoritedRecipeIDs.remove(recipeID)
        saveFavoritedRecipes()
    }

    /// Checks if a recipe is favorited.
    /// - Parameter id: The ID of the recipe to check.
    /// - Returns: `true` if the recipe is favorited, otherwise `false`.
    func isFavorited(recipeID: String) -> Bool {
        return favoritedRecipeIDs.contains(recipeID)
    }

    /// Clears the favorites count by resetting it to 0.
    func clearFavoritesCount() {
        favoritesCount = 0
        saveFavoritesCount()
    }
    
    // MARK: - Private Methods

    /// Increments the favorites count.
    private func incrementFavoritesCount() {
        favoritesCount += 1
        saveFavoritesCount()
    }

    /// Loads favorited recipes from UserDefaults.
    private func loadFavoritedRecipes() {
        if let savedIDs = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            favoritedRecipeIDs = Set(savedIDs)
        }
    }

    /// Saves the current set of favorited recipes to UserDefaults.
    private func saveFavoritedRecipes() {
        let idsArray = Array(favoritedRecipeIDs)
        UserDefaults.standard.set(idsArray, forKey: userDefaultsKey)
    }
    
    /// Loads the favorites count from UserDefaults.
    private func loadFavoritesCount() {
        favoritesCount = UserDefaults.standard.integer(forKey: counterKey)
    }

    /// Saves the favorites count to UserDefaults.
    private func saveFavoritesCount() {
        UserDefaults.standard.set(favoritesCount, forKey: counterKey)
    }
}

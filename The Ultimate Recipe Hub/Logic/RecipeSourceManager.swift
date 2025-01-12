//
//  RecipeResponseParser.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import Foundation

class RecipeSourceManager {
    
    // Singleton instance
    static let shared = RecipeSourceManager()
    
    // Cache for recipes keyed by ID
    private var recipesCache: [String: ProcessedRecipe] = [:]
    
    /// Initializes and loads the recipes, caching them for runtime.
    init() {
        loadRecipes()
    }
    
    /// Loads and caches recipes from the Resources folder.
    func loadRecipes() {
        guard let url = Bundle.main.url(forResource: "ProcessedRecipes", withExtension: "json") else {
            print("Failed to find ProcessedRecipes.json in Resources.")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let recipeResponse = parseRecipes(from: jsonData)
            cacheRecipes(from: recipeResponse)
        } catch {
            print("Failed to load recipes: \(error)")
        }
    }
    
    /// Finds a recipe by its ID.
    /// - Parameter id: The ID of the recipe to find.
    /// - Returns: The `ProcessedRecipe` if found, otherwise `nil`.
    func findRecipe(byID id: String) -> ProcessedRecipe? {
        return recipesCache[id]
    }
    
    /// Resolves recipe IDs into `ProcessedRecipe` objects for a specific collection.
    /// - Parameter collection: The `RecipeCollection` to resolve.
    /// - Returns: An array of `ProcessedRecipe` objects for the given collection.
    func resolveRecipes(for collection: RecipeCollection) -> [ProcessedRecipe] {
        return collection.recipes.compactMap { recipesCache[$0] }
    }
    
    /// Resolves recipe IDs into `ProcessedRecipe` objects for a given set of IDs.
    /// - Parameter recipeIDs: A `Set<String>` containing the IDs of recipes to resolve.
    /// - Returns: An array of `ProcessedRecipe` objects corresponding to the given IDs.
    func resolveRecipes(for recipeIDs: Set<String>) -> [ProcessedRecipe] {
        return recipeIDs.compactMap { recipesCache[$0] }
    }
    
    /// Parses JSON data into a `RecipeResponse` object.
    /// - Parameter jsonData: The JSON data to parse.
    /// - Returns: A `RecipeResponse` object if parsing succeeds, otherwise `nil`.
    private func parseRecipes(from jsonData: Data) -> RecipeResponse? {
        let decoder = JSONDecoder()
        do {
            let recipeResponse = try decoder.decode(RecipeResponse.self, from: jsonData)
            return recipeResponse
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    /// Caches recipes for quick lookup by ID.
    /// - Parameter recipeResponse: The `RecipeResponse` containing recipes to cache.
    private func cacheRecipes(from recipeResponse: RecipeResponse?) {
        guard let recipes = recipeResponse?.processedRecipes else { return }
        recipesCache = Dictionary(uniqueKeysWithValues: recipes.map { ($0.id, $0) })
    }
}

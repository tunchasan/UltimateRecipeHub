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
    
    /// Finds a recipe by its ID.
    /// - Parameter id: The ID of the recipe to find.
    /// - Returns: The `ProcessedRecipe` if found, otherwise `nil`.
    func findRecipe(byID id: String) -> ProcessedRecipe? {
        // Check if the recipe is already cached
        if let cachedRecipe = recipesCache[id] {
            return cachedRecipe
        }
        
        // Attempt to load the recipe from its corresponding file
        guard let recipe = loadRecipeFromFile(id: id) else {
            print("Recipe with ID \(id) not found in Resources/Recipes.")
            return nil
        }
        
        // Cache the loaded recipe and return it
        recipesCache[id] = recipe
        return recipe
    }
    
    /// Resolves recipe IDs into `ProcessedRecipe` objects for a given set of IDs.
    /// - Parameter recipeIDs: A `Set<String>` containing the IDs of recipes to resolve.
    /// - Returns: An array of `ProcessedRecipe` objects corresponding to the given IDs.
    func resolveRecipes(for recipeIDs: Set<String>) -> [ProcessedRecipe] {
        return recipeIDs.compactMap { findRecipe(byID: $0) }
    }
    
    /// Resolves recipes for a given `RecipeCollection`.
    /// - Parameter collection: The `RecipeCollection` to resolve.
    /// - Returns: An array of `ProcessedRecipe` objects corresponding to the recipes in the collection.
    func resolveRecipes(for collection: RecipeCollection) -> [ProcessedRecipe] {
        return collection.recipes.compactMap { findRecipe(byID: $0) }
    }
    
    /// Loads a recipe from its corresponding JSON file.
    /// - Parameter id: The ID of the recipe to load.
    /// - Returns: The `ProcessedRecipe` if loading and parsing succeed, otherwise `nil`.
    private func loadRecipeFromFile(id: String) -> ProcessedRecipe? {
        
        guard let url = Bundle.main.url(forResource: id, withExtension: "json") else {
            print("Failed to locate file for recipe ID \(id) in Recipes subdirectory.")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let recipe = try decoder.decode(ProcessedRecipe.self, from: jsonData)
            return recipe
        } catch {
            print("Error loading or parsing file for recipe ID \(id): \(error)")
            return nil
        }
    }
}

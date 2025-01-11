//
//  RecipeCollectionsResponse.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import Foundation

// MARK: - RecipeCollectionsResponse
struct RecipeCollectionsResponse: Codable {
    let date: String
    let entries: Int
    let collections: [RecipeCollection]
}

extension RecipeCollectionsResponse {
    /// Finds a `RecipeCollection` by its name.
    /// - Parameter name: The name of the collection to find.
    /// - Returns: The `RecipeCollection` if found, otherwise `nil`.
    func findCollection(byName name: String) -> RecipeCollection? {
        return collections.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }
    }
}

// MARK: - RecipeCollection
struct RecipeCollection: Codable {
    let id: String
    let name: String
    let entries: Int
    let recipes: [ProcessedRecipe]
}

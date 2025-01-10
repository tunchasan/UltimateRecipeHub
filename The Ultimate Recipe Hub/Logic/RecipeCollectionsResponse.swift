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

// MARK: - RecipeCollection
struct RecipeCollection: Codable {
    let id: String
    let name: String
    let entries: Int
    let recipes: [ProcessedRecipe]
}

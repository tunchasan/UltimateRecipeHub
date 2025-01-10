//
//  RecipeResponseParser.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import Foundation

class RecipeResponseParser {
    /// Parses JSON data into a RecipeResponse object.
    /// - Parameter jsonData: The JSON data to parse.
    /// - Returns: A `RecipeResponse` object if parsing succeeds, otherwise `nil`.
    func parseRecipes(from jsonData: Data) -> RecipeResponse? {
        let decoder = JSONDecoder()
        do {
            let recipeResponse = try decoder.decode(RecipeResponse.self, from: jsonData)
            return recipeResponse
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

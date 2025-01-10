//
//  RecipeCollectionParser.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import Foundation

class RecipeCollectionParser {
    func parseRecipeCollections(from jsonData: Data) -> RecipeCollectionsResponse? {
        let decoder = JSONDecoder()
        do {
            let collectionsResponse = try decoder.decode(RecipeCollectionsResponse.self, from: jsonData)
            return collectionsResponse
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key.stringValue)' not found:", context.debugDescription)
            print("Coding Path:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("Coding Path:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("Coding Path:", context.codingPath)
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted:", context.debugDescription)
        } catch {
            print("Error decoding JSON:", error)
        }
        return nil
    }
}

//
//  RecipeCollectionParser.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import Combine
import Foundation

class RecipeCollectionManager: ObservableObject {
    
    // Singleton instance
    static let shared = RecipeCollectionManager()

    // Published properties for loaded collections
    @Published private(set) var collectionsResponse: RecipeCollectionsResponse?
    @Published private(set) var popularCollectionsResponse: RecipeCollectionsResponse?
    
    // Static caches to persist data during runtime
    private static var cachedCollections: RecipeCollectionsResponse?
    private static var cachedPopularCollections: RecipeCollectionsResponse?
    
    init() {
        // Load collections on initialization
        loadRecipeCollections(fromResource: "Collections", type: .collections)
        loadRecipeCollections(fromResource: "PopularCollections", type: .popularCollections)
    }
    
    /// Loads and caches recipe collections from the specified resource file.
    /// - Parameters:
    ///   - resource: The name of the JSON resource file (without extension).
    ///   - type: The type of the collection to load (`.collections` or `.popularCollections`).
    private func loadRecipeCollections(fromResource resource: String, type: CollectionType) {
        switch type {
        case .collections:
            if let cached = Self.cachedCollections {
                // Use cached value if available
                collectionsResponse = cached
                return
            }
        case .popularCollections:
            if let cached = Self.cachedPopularCollections {
                // Use cached value if available
                popularCollectionsResponse = cached
                return
            }
        }
        
        // Load JSON data
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            print("Failed to locate resource \(resource).json")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            if let parsedResponse = parseRecipeCollections(from: jsonData) {
                // Cache and publish data based on type
                switch type {
                case .collections:
                    Self.cachedCollections = parsedResponse
                    collectionsResponse = parsedResponse
                case .popularCollections:
                    Self.cachedPopularCollections = parsedResponse
                    popularCollectionsResponse = parsedResponse
                }
            } else {
                print("Failed to parse JSON from resource \(resource).json")
            }
        } catch {
            print("Error loading JSON data: \(error)")
        }
    }
    
    /// Parses JSON data into a `RecipeCollectionsResponse` object.
    private func parseRecipeCollections(from jsonData: Data) -> RecipeCollectionsResponse? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(RecipeCollectionsResponse.self, from: jsonData)
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
    
    /// Finds a collection by name in the specified type.
    /// - Parameters:
    ///   - name: The name of the collection to find.
    ///   - type: The type of the collection (`.collections` or `.popularCollections`).
    /// - Returns: The `RecipeCollection` if found, otherwise `nil`.
    func findCollection(byName name: String, type: CollectionType) -> RecipeCollection? {
        switch type {
        case .collections:
            return Self.cachedCollections?.collections.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }
        case .popularCollections:
            return Self.cachedPopularCollections?.collections.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }
        }
    }
    
    // Enum to differentiate collection types
    enum CollectionType {
        case collections
        case popularCollections
    }
}

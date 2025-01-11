//
//  RecipeResponse.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import Foundation

// MARK: - Root Model
struct RecipeResponse: Codable {
    let processedDetails: ProcessedDetails
    let processedRecipes: [ProcessedRecipe]
    
    enum CodingKeys: String, CodingKey {
        case processedDetails = "processed_details"
        case processedRecipes = "processed_recipes"
    }
}

// MARK: - ProcessedDetails
struct ProcessedDetails: Codable {
    let date: String
    let entries: Int
}

// MARK: - ProcessedRecipe
struct ProcessedRecipe: Codable, Identifiable {
    let id: String
    let recipe: RecipeModel
    let processedInformations: ProcessedInformations
    
    enum CodingKeys: String, CodingKey {
        case id
        case recipe
        case processedInformations = "processed_informations" // Maps directly to JSON key
    }
}

struct RecipeModel: Codable {
    let name: String
    let description: String
    let tag1, tag2: [String] // These keys must be present in the JSON
    let sourceURL, imageURL: String
    let ratingCount, reviewCount: Int
    let rating: Double
    let serves: Int
    let subscription: String
    let prepTime, cookTime: TimeInfo
    let mealType: [String]
    let dishType: String
    let specialConsideration, preparationType, ingredientsFilter: [String]?
    let cuisine, difficulty: String
    let macros: Macros
    let ingredients: [Ingredient]
    let steps: [String]
    let calories: Int
    
    enum CodingKeys: String, CodingKey {
        case name, description
        case tag1 = "tag_1" // Matches JSON key `tag_1`
        case tag2 = "tag_2" // Matches JSON key `tag_2`
        case sourceURL = "source_url"
        case imageURL = "image_url"
        case ratingCount = "rating_count"
        case reviewCount = "review_count"
        case rating, serves, subscription
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case mealType = "meal_type"
        case dishType = "dish_type"
        case specialConsideration = "special_consideration"
        case preparationType = "preparation_type"
        case ingredientsFilter = "ingredients_filter"
        case cuisine, difficulty, macros, ingredients, steps, calories
    }
}

extension RecipeModel {
    enum SubscriptionType: String {
        case pro = "Pro"
        case free = "Free"
    }
    
    enum DifficultyType: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
    
    var subscriptionType: SubscriptionType {
        return SubscriptionType(rawValue: subscription) ?? .free
    }
    
    var isProSubscription: Bool {
        return subscriptionType == .pro
    }
    
    var difficultyType: DifficultyType {
        switch difficulty.lowercased() {
        case "easy":
            return .beginner
        case "intermediate":
            return .intermediate
        case "hard":
            return .advanced
        default:
            return .beginner
        }
    }
    
    var combinedTags: [String] {
        let combinedSet = Set(tag1 + tag2) // Combine and eliminate duplicates
        return combinedSet.map { $0.uppercased() }.sorted() // Convert to uppercase and sort alphabetically (optional)
    }
    
    var formattedIngredients: [(String, String)] {
        return ingredients.map { ingredient in
            // Format the ingredientAmount to remove trailing .0
            let formattedAmount = ingredient.ingredientAmount.truncatingRemainder(dividingBy: 1) == 0
                ? String(format: "%.0f", ingredient.ingredientAmount)
                : String(ingredient.ingredientAmount)
            
            // Combine the amount, unit, and name
            let amountUnit = ingredient.ingredientAmount == 0
                ? ""
                : "\(formattedAmount) \(ingredient.ingredientUnit)".trimmingCharacters(in: .whitespaces)
            
            return (amountUnit, ingredient.ingredientName)
        }
    }
}

// MARK: - TimeInfo
struct TimeInfo: Codable {
    let duration: Int
    let timeUnit: String
    
    enum CodingKeys: String, CodingKey {
        case duration
        case timeUnit = "time_unit"
    }
}

// MARK: - Macros
struct Macros: Codable {
    let carbs, protein, fat: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let ingredientName: String
    let ingredientAmount: Double
    let ingredientUnit: String
    
    enum CodingKeys: String, CodingKey {
        case ingredientName = "ingredient_name"
        case ingredientAmount = "ingredient_amount"
        case ingredientUnit = "ingredient_unit"
    }
}

// MARK: - ProcessedInformations
struct ProcessedInformations: Codable {
    let isSideDish: Bool
    let recipeTypes: [String]
    
    enum CodingKeys: String, CodingKey {
        case isSideDish = "is_side_dish"
        case recipeTypes = "recipe_types"
    }
}

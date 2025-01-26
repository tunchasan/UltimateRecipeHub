//
//  RecipeCollectionType.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.01.2025.
//

import Combine
import Foundation

enum RecipeCollectionType: String, CaseIterable {
    case breakfast = "Breakfast"
    case dinner = "Dinner"
    case lunch = "Lunch"
    case sideBreakfast = "SideBreakfast"
    case sideDinner = "SideDinner"
    case sideLunch = "SideLunch"
}

struct DailyMeals: Codable {
    let date: Date
    let breakfast: String
    let sideBreakfast: String
    let lunch: String
    let sideLunch: String
    let dinner: String
    let sideDinner: String
    let macros: Macros
    let calories: Int
}

struct WeeklyMeals: Codable {
    let startDate: Date
    let endDate: Date
    let dailyMeals: [DailyMeals]
}

struct CategoryCollection: Codable {
    let processedDetails: ProcessedDetails
    let processedRecipes: [String]
    
    enum CodingKeys: String, CodingKey {
        case processedDetails = "processed_details"
        case processedRecipes = "processed_recipes"
    }
}

class MealPlanManager: ObservableObject {
    static let shared = MealPlanManager()
    
    @Published var currentWeeklyPlan: WeeklyMeals?
    
    private let calendar = Calendar.current
    
    private init() {
        loadOrGenerateWeeklyMeals()
    }
    
    /// Loads the current weekly meal plan or generates a new one if none exists.
    private func loadOrGenerateWeeklyMeals() {
        if let loadedPlan = MealPlanLoader.shared.getWeeklyPlan() {
            currentWeeklyPlan = loadedPlan
        } else {
            currentWeeklyPlan = generateWeeklyMeals(startingFrom: calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date())
        }
    }
    
    /// Generates a weekly meal plan starting from the provided date.
    /// - Parameter startDate: The start date of the week.
    /// - Returns: A `WeeklyMeals` object containing daily meal plans for the week.
    func generateWeeklyMeals(startingFrom startDate: Date) -> WeeklyMeals? {
        var dailyMeals: [DailyMeals] = []
        
        // Generate meals for 7 days
        for dayOffset in 0..<7 {
            guard let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate),
                  let dailyMeal = generateDailyMeals(for: currentDate) else {
                print("Failed to generate daily meals for day \(dayOffset)")
                return nil
            }
            
            dailyMeals.append(dailyMeal)
        }
        
        // Determine start and end dates for the weekly plan
        let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? startDate
        let newWeeklyPlan = WeeklyMeals(startDate: startDate, endDate: endDate, dailyMeals: dailyMeals)
        MealPlanLoader.shared.saveWeeklyMeals(newWeeklyPlan)
        return newWeeklyPlan
    }
    
    /// Generates a `DailyMeals` object for a specific date.
    /// - Parameter date: The date for which to generate the daily meals.
    /// - Returns: A `DailyMeals` object, or `nil` if required collections are missing or invalid.
    func generateDailyMeals(for date: Date) -> DailyMeals? {
        let collectionLoader = MealPlanCollectionLoader.shared
        
        guard
            let breakfastCollection = collectionLoader.getCollection(byType: .breakfast),
            let sideBreakfastCollection = collectionLoader.getCollection(byType: .sideBreakfast),
            let lunchCollection = collectionLoader.getCollection(byType: .lunch),
            let sideLunchCollection = collectionLoader.getCollection(byType: .sideLunch),
            let dinnerCollection = collectionLoader.getCollection(byType: .dinner),
            let sideDinnerCollection = collectionLoader.getCollection(byType: .sideDinner)
        else {
            print("Failed to load one or more collections for daily meals.")
            return nil
        }
        
        func randomRecipeID(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> String? {
            let availableIDs = collection.processedRecipes.filter { !excludedIDs.contains($0) }
            guard let selectedID = availableIDs.randomElement() else { return nil }
            excludedIDs.insert(selectedID)
            return selectedID
        }
        
        var usedRecipeIDs = Set<String>()
        
        guard
            let breakfast = randomRecipeID(from: breakfastCollection, excluding: &usedRecipeIDs),
            let sideBreakfast = randomRecipeID(from: sideBreakfastCollection, excluding: &usedRecipeIDs),
            let lunch = randomRecipeID(from: lunchCollection, excluding: &usedRecipeIDs),
            let sideLunch = randomRecipeID(from: sideLunchCollection, excluding: &usedRecipeIDs),
            let dinner = randomRecipeID(from: dinnerCollection, excluding: &usedRecipeIDs),
            let sideDinner = randomRecipeID(from: sideDinnerCollection, excluding: &usedRecipeIDs)
        else {
            print("Failed to generate unique recipe IDs for daily meals.")
            return nil
        }
        
        return DailyMeals(
            date: date,
            breakfast: breakfast,
            sideBreakfast: sideBreakfast,
            lunch: lunch,
            sideLunch: sideLunch,
            dinner: dinner,
            sideDinner: sideDinner,
            macros: Macros(carbs: 250, protein: 20, fat: 30),
            calories: 250
        )
    }
}

class MealPlanCollectionLoader {
    // Singleton instance
    static let shared = MealPlanCollectionLoader()
    
    // Private cache for collections
    private var collectionsCache: [RecipeCollectionType: CategoryCollection] = [:]
    
    // Private initializer to enforce singleton usage
    private init() {
        loadAllCollections()
    }
    
    /// Loads all recipe collections and caches them.
    private func loadAllCollections() {
        for type in RecipeCollectionType.allCases {
            if let collection = loadCollection(named: type.rawValue) {
                collectionsCache[type] = collection
            }
        }
    }
    
    /// Loads a specific collection from the Resources folder.
    /// - Parameter name: The name of the dataset to load.
    /// - Returns: A `CategoryCollection` object if parsing succeeds, otherwise `nil`.
    private func loadCollection(named name: String) -> CategoryCollection? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            print("Failed to find \(name).json in Resources.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(CategoryCollection.self, from: data)
        } catch {
            print("Failed to load \(name).json: \(error)")
            return nil
        }
    }
    
    /// Retrieves a cached collection by its type.
    /// - Parameter type: The `RecipeCollectionType` of the dataset to retrieve.
    /// - Returns: A `CategoryCollection` object if found, otherwise `nil`.
    func getCollection(byType type: RecipeCollectionType) -> CategoryCollection? {
        return collectionsCache[type]
    }
    
    /// Clears all cached collections.
    func clearCache() {
        collectionsCache.removeAll()
    }
}

class MealPlanLoader {
    
    // Singleton instance
    static let shared = MealPlanLoader()
    private let userDefaultsKey = "WeeklyMeals"
    private var cachedWeeklyMeals: WeeklyMeals?
    
    // Private initializer to ensure singleton usage
    private init() {
        loadWeeklyMeals()
    }
    
    /// Saves a `WeeklyMeals` object to UserDefaults.
    /// - Parameter weeklyMeals: The `WeeklyMeals` object to save.
    func saveWeeklyMeals(_ weeklyMeals: WeeklyMeals) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(weeklyMeals)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            cachedWeeklyMeals = weeklyMeals // Update cache
            print("Weekly meals saved successfully.")
        } catch {
            print("Failed to save weekly meals: \(error.localizedDescription)")
        }
    }
    
    /// Loads a `WeeklyMeals` object from UserDefaults and caches it.
    private func loadWeeklyMeals() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            print("No weekly meals found in UserDefaults.")
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            cachedWeeklyMeals = try decoder.decode(WeeklyMeals.self, from: data)
            print("Weekly meals loaded successfully.")
        } catch {
            print("Failed to load weekly meals: \(error.localizedDescription)")
        }
    }
    
    /// Retrieves the currently saved `WeeklyMeals` object.
    /// - Returns: A `WeeklyMeals` object if available, otherwise `nil`.
    func getWeeklyPlan() -> WeeklyMeals? {
        return cachedWeeklyMeals
    }
    
    /// Clears saved weekly meals from UserDefaults and cache.
    func clearWeeklyMeals() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        cachedWeeklyMeals = nil
        print("Weekly meals cleared from UserDefaults.")
    }
}

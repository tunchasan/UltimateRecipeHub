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
    var breakfast: String
    var sideBreakfast: String
    var lunch: String
    var sideLunch: String
    var dinner: String
    var sideDinner: String
    var macros: Macros
    var calories: Int

    /// Clears all variables except the date.
    mutating func clearMeals() {
        breakfast = ""
        sideBreakfast = ""
        lunch = ""
        sideLunch = ""
        dinner = ""
        sideDinner = ""
        macros = Macros(carbs: 0, protein: 0, fat: 0)
        calories = 0
    }
}

struct WeeklyMeals: Codable {
    let startDate: Date
    let endDate: Date
    var dailyMeals: [DailyMeals]
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
            generateWeeklyMeals()
        }
    }
    
    func removeWeeklyMeals(){
        currentWeeklyPlan = nil
        MealPlanLoader.shared.clearWeeklyMeals()
    }
    
    /// Updates the recipe for a specific day and slot by selecting a new recipe ID.
    /// - Parameters:
    ///   - date: The date for which the recipe should be updated.
    ///   - slot: The meal slot to update (e.g., breakfast, lunch).
    func updateRecipe(for date: Date, in slot: MealSlot.MealType) {
        guard var weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }

        // Find the daily meal plan for the specified date
        guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
            print("No meals found for the specified date.")
            return
        }

        // Get the appropriate collection for the given slot
        guard let collection = MealPlanCollectionLoader.shared.getCollection(byType: slot.collectionType) else {
            print("Failed to find a collection for the specified slot.")
            return
        }

        // Select a new recipe ID
        var usedRecipeIDs = Set<String>()
        weeklyPlan.dailyMeals.forEach { dailyMeal in
            usedRecipeIDs.formUnion([
                dailyMeal.breakfast,
                dailyMeal.sideBreakfast,
                dailyMeal.lunch,
                dailyMeal.sideLunch,
                dailyMeal.dinner,
                dailyMeal.sideDinner
            ])
        }

        guard let newRecipeID = collection.processedRecipes.filter({ !usedRecipeIDs.contains($0) }).randomElement() else {
            print("No available recipes for the specified slot.")
            return
        }

        // Update the specific slot with the new recipe ID
        switch slot {
        case .breakfast:
            weeklyPlan.dailyMeals[index].breakfast = newRecipeID
        case .sideBreakfast:
            weeklyPlan.dailyMeals[index].sideBreakfast = newRecipeID
        case .lunch:
            weeklyPlan.dailyMeals[index].lunch = newRecipeID
        case .sideLunch:
            weeklyPlan.dailyMeals[index].sideLunch = newRecipeID
        case .dinner:
            weeklyPlan.dailyMeals[index].dinner = newRecipeID
        case .sideDinner:
            weeklyPlan.dailyMeals[index].sideDinner = newRecipeID
        }

        // Save the updated weekly plan
        currentWeeklyPlan = weeklyPlan
        MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
    }
    
    /// Updates the recipe for a specific day and slot with a provided recipe ID.
    /// - Parameters:
    ///   - date: The date for which the recipe should be updated.
    ///   - slot: The meal slot to update (e.g., breakfast, lunch).
    ///   - recipeID: The new recipe ID to assign to the specified slot.
    func updateRecipe(for date: Date, in slot: MealSlot.MealType, with recipeID: String) {
        guard var weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }

        // Find the daily meal plan for the specified date
        guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
            print("No meals found for the specified date.")
            return
        }

        // Ensure the new recipe ID exists in the relevant collection
        guard let collection = MealPlanCollectionLoader.shared.getCollection(byType: slot.collectionType),
              collection.processedRecipes.contains(recipeID) else {
            print("The provided recipe ID is not valid for the specified slot.")
            return
        }

        // Update the specific slot with the provided recipe ID
        switch slot {
        case .breakfast:
            weeklyPlan.dailyMeals[index].breakfast = recipeID
        case .sideBreakfast:
            weeklyPlan.dailyMeals[index].sideBreakfast = recipeID
        case .lunch:
            weeklyPlan.dailyMeals[index].lunch = recipeID
        case .sideLunch:
            weeklyPlan.dailyMeals[index].sideLunch = recipeID
        case .dinner:
            weeklyPlan.dailyMeals[index].dinner = recipeID
        case .sideDinner:
            weeklyPlan.dailyMeals[index].sideDinner = recipeID
        }

        // Save the updated weekly plan
        currentWeeklyPlan = weeklyPlan
        MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
    }
    
    /// Generates and updates meals for a specific day.
    /// - Parameter date: The date for which to generate and update the daily meals.
    func generateMealsForSpecificDay(for date: Date) {
        guard var weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }

        // Generate new meals for the specific day
        guard let newDailyMeals = generateDailyMeals(for: date) else {
            print("Failed to generate meals for the specified date.")
            return
        }

        // Update the dailyMeals array with the new meals
        if let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            weeklyPlan.dailyMeals[index] = newDailyMeals
        } else {
            print("Specified date not found in the current weekly plan.")
            return
        }

        // Save the updated weekly plan
        currentWeeklyPlan = weeklyPlan
        MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
    }
    
    /// Clears  meals for a specific day.
    /// - Parameter date: The date of the meals to remove.
    func removeDailyMeals(for date: Date) {
        guard var weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }

        // Find and clear the meals for the given date
        if let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            // Clear meals for the day but retain the date
            weeklyPlan.dailyMeals[index].clearMeals()
        } else {
            print("No meals found for the specified date.")
        }

        // Update and save the modified plan
        currentWeeklyPlan = weeklyPlan
        MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
    }
    
    /// Generates a weekly meal plan starting from the provided date.
    /// - Parameter startDate: The start date of the week.
    /// - Returns: A `WeeklyMeals` object containing daily meal plans for the week.
    func generateWeeklyMeals() {
        var dailyMeals: [DailyMeals] = []
        let startDate = calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        
        // Generate meals for 7 days
        for dayOffset in 0..<7 {
            guard let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate),
                  let dailyMeal = generateDailyMeals(for: currentDate) else {
                print("Failed to generate daily meals for day \(dayOffset)")
                return
            }
            
            dailyMeals.append(dailyMeal)
        }
        
        // Determine start and end dates for the weekly plan
        let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? startDate
        let newWeeklyPlan = WeeklyMeals(startDate: startDate, endDate: endDate, dailyMeals: dailyMeals)
        MealPlanLoader.shared.saveWeeklyMeals(newWeeklyPlan)
        currentWeeklyPlan = newWeeklyPlan
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

extension MealSlot.MealType {
    var collectionType: RecipeCollectionType {
        switch self {
        case .breakfast: return .breakfast
        case .sideBreakfast: return .sideBreakfast
        case .lunch: return .lunch
        case .sideLunch: return .sideLunch
        case .dinner: return .dinner
        case .sideDinner: return .sideDinner
        }
    }
}

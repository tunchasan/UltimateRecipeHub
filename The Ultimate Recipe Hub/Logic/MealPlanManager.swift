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
    var breakfast: ProcessedRecipe?
    var sideBreakfast: ProcessedRecipe?
    var lunch: ProcessedRecipe?
    var sideLunch: ProcessedRecipe?
    var dinner: ProcessedRecipe?
    var sideDinner: ProcessedRecipe?
    var macros: Macros
    var calories: Int

    /// Clears all meals except the date.
    mutating func clearMeals() {
        breakfast = nil
        sideBreakfast = nil
        lunch = nil
        sideLunch = nil
        dinner = nil
        sideDinner = nil
        macros = Macros(carbs: 0, protein: 0, fat: 0)
        calories = 0
    }
}

struct WeeklyMeals: Codable {
    let startDate: Date
    let endDate: Date
    var dailyMeals: [DailyMeals]
}

struct ReplaceMode {
    var isEnabled: Bool = false
    var hasReplaced: Bool = false
    var replaceRecipe: ProcessedRecipe?
    var replacedRecipe: ProcessedRecipe?
    var replacedSlotType: MealSlot.MealType?
    var replacedDate: Date?
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
    
    @Published var replaceMode: ReplaceMode
    
    @Published private(set) var updatesCount: Int = 0
    
    private let calendar = Calendar.current
    
    private let counterKey = "UpdatesPlanCount"

    private init() {
        replaceMode = ReplaceMode()
        loadOrGenerateWeeklyMeals()
        loadUpdatesCount()
    }
    
    /// Clears the favorites count by resetting it to 0.
    func clearUpdatesCount() {
        updatesCount = 0
        saveUpdatesCount()
    }
    
    /// Increments the favorites count.
    private func incrementUpdatesCount() {
        updatesCount += 1
        saveUpdatesCount()
    }
    
    /// Loads the favorites count from UserDefaults.
    private func loadUpdatesCount() {
        updatesCount = UserDefaults.standard.integer(forKey: counterKey)
    }

    /// Saves the favorites count to UserDefaults.
    private func saveUpdatesCount() {
        UserDefaults.standard.set(updatesCount, forKey: counterKey)
    }
    
    /// Loads the current weekly meal plan or generates a new one if none exists.
    private func loadOrGenerateWeeklyMeals() {
        if let loadedPlan = MealPlanLoader.shared.getWeeklyPlan() {
            currentWeeklyPlan = loadedPlan
        } else {
            generateWeeklyMeals()
        }
    }
    
    func onRecieveReplacedRecipe(replacedRecipe: ProcessedRecipe, replacedSlot: MealSlot.MealType, replacedDate: Date) {
        replaceMode.replacedRecipe = replacedRecipe
        replaceMode.replacedSlotType = replacedSlot
        replaceMode.replacedDate = replacedDate
        replaceMode.isEnabled = true
    }
    
    func clearReplacedRecipe() {
        replaceMode.replacedSlotType = nil
        replaceMode.replacedRecipe = nil
        replaceMode.replacedDate = nil
        replaceMode.isEnabled = false
    }
    
    func onRecieveReplaceRecipe(replaceRecipe: ProcessedRecipe) {
        replaceMode.replaceRecipe = replaceRecipe
    }
    
    func clearReplaceMode() {
        replaceMode.isEnabled = false
        replaceMode.replacedDate = nil
        replaceMode.replaceRecipe = nil
        replaceMode.hasReplaced = false
        replaceMode.replacedRecipe = nil
        replaceMode.replacedSlotType = nil
    }
    
    func removeWeeklyMeals() {
        let startDate = calendar.startOfDay(for: Date()) // Start from today

        var dailyMeals: [DailyMeals] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                let emptyDailyMeal = DailyMeals(
                    date: date,
                    breakfast: nil,
                    sideBreakfast: nil,
                    lunch: nil,
                    sideLunch: nil,
                    dinner: nil,
                    sideDinner: nil,
                    macros: Macros(carbs: 0, protein: 0, fat: 0),
                    calories: 0
                )
                dailyMeals.append(emptyDailyMeal)
            }
        }
        
        let newWeeklyPlan = WeeklyMeals(startDate: startDate, endDate: dailyMeals.last?.date ?? startDate, dailyMeals: dailyMeals)

        currentWeeklyPlan = newWeeklyPlan
        MealPlanLoader.shared.saveWeeklyMeals(newWeeklyPlan)
    }
    
    func updateRecipe() {
        incrementUpdatesCount()
        
        updateRecipe(
            for: replaceMode.replacedDate!,
            in: replaceMode.replacedSlotType!,
            with: replaceMode.replaceRecipe!.id
        )
        
        replaceMode.hasReplaced = true        
    }
    
    /// Updates the recipe for a specific day and slot by selecting a new recipe.
    /// - Parameters:
    ///   - date: The date for which the recipe should be updated.
    ///   - slot: The meal slot to update.
    func updateRecipe(for date: Date, in slot: MealSlot.MealType) {
        guard var weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }

        guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
            print("No meals found for the specified date.")
            return
        }

        guard let collection = MealPlanCollectionLoader.shared.getCollection(byType: slot.collectionType) else {
            print("Failed to find a collection for the specified slot.")
            return
        }

        // Convert used recipe IDs into a Set<String> before passing to the function
        var usedRecipeIDs: Set<String> = Set(
            weeklyPlan.dailyMeals.flatMap {
                [$0.breakfast?.id, $0.sideBreakfast?.id, $0.lunch?.id, $0.sideLunch?.id, $0.dinner?.id, $0.sideDinner?.id]
            }.compactMap { $0 } // Ensure nil values are removed
        )

        // Select a new recipe
        guard let newRecipe = selectRandomRecipe(from: collection, excluding: &usedRecipeIDs) else {
            print("No available recipes for the specified slot.")
            return
        }

        // Update the meal slot
        updateMealSlot(for: &weeklyPlan.dailyMeals[index], slot: slot, newRecipe: newRecipe)

        // Save the updated weekly plan
        currentWeeklyPlan = weeklyPlan
        MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
    }
    
    /// Selects a random unique `ProcessedRecipe` from a given collection.
    /// - Parameters:
    ///   - collection: The `CategoryCollection` to choose a recipe from.
    ///   - excludedIDs: A `Set<String>` of IDs to avoid duplicates.
    /// - Returns: A `ProcessedRecipe` if successful, otherwise `nil`.
    func selectRandomRecipe(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> ProcessedRecipe? {
        let availableIDs = collection.processedRecipes.filter { !excludedIDs.contains($0) }
        
        guard let selectedID = availableIDs.randomElement(),
              let selectedRecipe = RecipeSourceManager.shared.findRecipe(byID: selectedID) else {
            return nil
        }

        excludedIDs.insert(selectedID) // Mark the ID as used
        return selectedRecipe
    }

    /// Updates a specific meal slot in a given `DailyMeals` instance.
    /// - Parameters:
    ///   - dailyMeal: The `DailyMeals` instance to update.
    ///   - slot: The meal slot to update.
    ///   - newRecipe: The new recipe to assign.
    private func updateMealSlot(for dailyMeal: inout DailyMeals, slot: MealSlot.MealType, newRecipe: ProcessedRecipe) {
        switch slot {
        case .breakfast:
            dailyMeal.breakfast = newRecipe
        case .sideBreakfast:
            dailyMeal.sideBreakfast = newRecipe
        case .lunch:
            dailyMeal.lunch = newRecipe
        case .sideLunch:
            dailyMeal.sideLunch = newRecipe
        case .dinner:
            dailyMeal.dinner = newRecipe
        case .sideDinner:
            dailyMeal.sideDinner = newRecipe
        }
    }
    
    /// Retrieves a random unique `ProcessedRecipe` from a given collection.
    /// - Parameters:
    ///   - collection: The `CategoryCollection` to choose a recipe from.
    ///   - excludedIDs: A `Set<String>` of IDs to avoid duplicates.
    /// - Returns: A `ProcessedRecipe` if successful, otherwise `nil`.
    func randomRecipe(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> ProcessedRecipe? {
        let availableIDs = collection.processedRecipes.filter { !excludedIDs.contains($0) }
        
        guard let selectedID = availableIDs.randomElement(),
              let selectedRecipe = RecipeSourceManager.shared.findRecipe(byID: selectedID) else {
            return nil
        }

        excludedIDs.insert(selectedID) // Mark the ID as used
        return selectedRecipe
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

        // Fetch the new recipe
        guard let newRecipe = RecipeSourceManager.shared.findRecipe(byID: recipeID) else {
            print("Failed to find recipe with ID \(recipeID)")
            return
        }

        // Find the index of the day to update
        guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
            print("No meals found for the specified date.")
            return
        }

        // Update the specified meal slot with the `ProcessedRecipe`
        updateMealSlot(for: &weeklyPlan.dailyMeals[index], slot: slot, newRecipe: newRecipe)

        // Save the updated plan
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
        let startDate = calendar.date(byAdding: .day, value: 0, to: Date()) ?? Date()
        
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

        var usedRecipeIDs = Set<String>()

        guard
            let breakfast = randomRecipe(from: breakfastCollection, excluding: &usedRecipeIDs),
            let sideBreakfast = randomRecipe(from: sideBreakfastCollection, excluding: &usedRecipeIDs),
            let lunch = randomRecipe(from: lunchCollection, excluding: &usedRecipeIDs),
            let sideLunch = randomRecipe(from: sideLunchCollection, excluding: &usedRecipeIDs),
            let dinner = randomRecipe(from: dinnerCollection, excluding: &usedRecipeIDs),
            let sideDinner = randomRecipe(from: sideDinnerCollection, excluding: &usedRecipeIDs)
        else {
            print("Failed to generate unique recipes for daily meals.")
            return nil
        }

        // Sum up macros and calories
        let totalCalories = (breakfast.recipe.calories ?? 0) +
                            (sideBreakfast.recipe.calories ?? 0) +
                            (lunch.recipe.calories ?? 0) +
                            (sideLunch.recipe.calories ?? 0) +
                            (dinner.recipe.calories ?? 0) +
                            (sideDinner.recipe.calories ?? 0)

        let totalMacros = Macros(
            carbs: (breakfast.recipe.macros?.carbs ?? 0) +
                   (sideBreakfast.recipe.macros?.carbs ?? 0) +
                   (lunch.recipe.macros?.carbs ?? 0) +
                   (sideLunch.recipe.macros?.carbs ?? 0) +
                   (dinner.recipe.macros?.carbs ?? 0) +
                   (sideDinner.recipe.macros?.carbs ?? 0),
            
            protein: (breakfast.recipe.macros?.protein ?? 0) +
                     (sideBreakfast.recipe.macros?.protein ?? 0) +
                     (lunch.recipe.macros?.protein ?? 0) +
                     (sideLunch.recipe.macros?.protein ?? 0) +
                     (dinner.recipe.macros?.protein ?? 0) +
                     (sideDinner.recipe.macros?.protein ?? 0),
            
            fat: (breakfast.recipe.macros?.fat ?? 0) +
                 (sideBreakfast.recipe.macros?.fat ?? 0) +
                 (lunch.recipe.macros?.fat ?? 0) +
                 (sideLunch.recipe.macros?.fat ?? 0) +
                 (dinner.recipe.macros?.fat ?? 0) +
                 (sideDinner.recipe.macros?.fat ?? 0)
        )

        return DailyMeals(
            date: date,
            breakfast: breakfast,
            sideBreakfast: sideBreakfast,
            lunch: lunch,
            sideLunch: sideLunch,
            dinner: dinner,
            sideDinner: sideDinner,
            macros: totalMacros,
            calories: totalCalories
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

extension DailyMeals {
    /// Checks if all meal slots are empty.
    /// - Returns: `true` if all meal slots are empty, otherwise `false`.
    func isEmpty() -> Bool {
        return breakfast == nil &&
               sideBreakfast == nil &&
               lunch == nil &&
               sideLunch == nil &&
               dinner == nil &&
               sideDinner == nil
    }
}

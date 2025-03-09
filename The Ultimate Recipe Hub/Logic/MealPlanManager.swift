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
    var breakfast: MealEntry?
    var sideBreakfast: MealEntry?
    var lunch: MealEntry?
    var sideLunch: MealEntry?
    var dinner: MealEntry?
    var sideDinner: MealEntry?
    var macros: Macros
    var calories: Int
    var waterChallenge: WaterChallengeEntry
    
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
        waterChallenge = WaterChallengeEntry(goal: 2, progress: 0)
    }
}

/// New Struct for Meals with `isEaten`
struct MealEntry: Codable {
    var meal: ProcessedRecipe
    var isEaten: Bool = false // Default: Not eaten
}

struct WaterChallengeEntry: Codable {
    var goal: CGFloat
    var progress: CGFloat
}

extension WaterChallengeEntry {
    /// Returns the progress as a percentage (0-100), ensuring it's between 0 and 100.
    func alphaProgress() -> CGFloat {
        return min(max((progress / goal), 0), 1)
    }
}

struct WeeklyMeals: Codable {
    let startDate: Date
    let endDate: Date
    var dailyMeals: [DailyMeals]
}

struct ReplaceMode {
    var handledByAICoach: Bool = false
    var replaceRecipe: ProcessedRecipe?
    var replacedRecipe: ProcessedRecipe?
    var replacedSlotType: MealSlot.MealType?
    var replacedDate: Date?
}

struct CategoryCollection: Codable {
    let processedDetails: ProcessedDetails
    let processedRecipesEasy: [String]
    let processedRecipesIntermediate: [String]
    let processedRecipesHard: [String]

    enum CodingKeys: String, CodingKey {
        case processedDetails = "processed_details"
        case processedRecipesEasy = "processed_recipes_easy"
        case processedRecipesIntermediate = "processed_recipes_intermediate"
        case processedRecipesHard = "processed_recipes_hard"
    }
}

class MealPlanManager: ObservableObject {
    
    static let shared = MealPlanManager()
    
    @Published var currentWeeklyPlan: WeeklyMeals?
    
    var replaceMode: ReplaceMode
    
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
    func incrementUpdatesCount() {
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
            generateEmptyWeeklyMeals()
        }
    }
    
    /// Publisher to notify when `handleReplaceMode(_:)` is manually triggered
    let onHandleReplaceMode = PassthroughSubject<ReplaceMode, Never>()
    
    /// Publisher to notify when `completeReplaceMode(_:)` is manually triggered
    let onCompleteReplaceMode = PassthroughSubject<Void, Never>()
    
    /// Manually invokes a replace mode update (does not trigger on change)
    func handleReplaceMode() {
        onHandleReplaceMode.send(replaceMode) // Notify manually
    }
    
    /// Manually invokes a replace mode update (does not trigger on change)
    func completeReplaceMode() {
        onCompleteReplaceMode.send() // Notify manually
    }
    
    func onRecieveReplacedRecipe(replacedRecipe: ProcessedRecipe, replacedSlot: MealSlot.MealType, replacedDate: Date, suggestion: Bool = false) {
        replaceMode.handledByAICoach = suggestion
        replaceMode.replacedRecipe = replacedRecipe
        replaceMode.replacedSlotType = replacedSlot
        replaceMode.replacedDate = replacedDate
        handleReplaceMode()
    }
    
    func onRecieveReplacedRecipe(replacedRecipe: ProcessedRecipe, suggestion: Bool = false) {
        guard replaceMode.replacedDate != nil else {
            print("No replacedDate found.")
            return
        }
        
        guard replaceMode.replacedSlotType != nil else {
            print("No replacedSlotType found.")
            return
        }
        
        replaceMode.handledByAICoach = suggestion
        replaceMode.replacedRecipe = replacedRecipe
        handleReplaceMode()
    }
    
    func onUpdateReplaceMode(replaceDate: Date, replacedSlot: MealSlot.MealType) {
        replaceMode.replacedSlotType = replacedSlot
        replaceMode.replacedDate = replaceDate
    }
    
    func clearReplacedRecipe() {
        replaceMode.replacedSlotType = nil
        replaceMode.handledByAICoach = false
        replaceMode.replacedRecipe = nil
        replaceMode.replacedDate = nil
    }
    
    func onRecieveReplaceRecipe(replaceRecipe: ProcessedRecipe) {
        replaceMode.replaceRecipe = replaceRecipe
    }
    
    func clearReplaceMode() {
        replaceMode.replacedDate = nil
        replaceMode.replaceRecipe = nil
        replaceMode.replacedRecipe = nil
        replaceMode.replacedSlotType = nil
        replaceMode.handledByAICoach = false
    }
    
    func removeWeeklyMeals(with save: Bool = true) {
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
                    calories: 0,
                    waterChallenge: WaterChallengeEntry(goal: 2, progress: 0)
                )
                dailyMeals.append(emptyDailyMeal)
            }
        }
        
        let newWeeklyPlan = WeeklyMeals(startDate: startDate, endDate: dailyMeals.last?.date ?? startDate, dailyMeals: dailyMeals)
        
        currentWeeklyPlan = newWeeklyPlan
        
        if save {
            MealPlanLoader.shared.saveWeeklyMeals(newWeeklyPlan)
        }
    }
    
    func updateRecipe() {
        
        incrementUpdatesCount()
        
        updateRecipe(
            for: replaceMode.replacedDate!,
            in: replaceMode.replacedSlotType!,
            with: replaceMode.replaceRecipe!.id
        )
        
        completeReplaceMode()
    }
    
    /// Updates the recipe for a specific day and slot by selecting a new recipe.
    /// - Parameters:
    ///   - date: The date for which the recipe should be updated.
    ///   - slot: The meal slot to update.
    func assignRandomRecipeToReplaceRecipe(for date: Date, in slot: MealSlot.MealType) {
        guard let weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }
        
        guard weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) != nil else {
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
                [$0.breakfast?.meal.id, $0.sideBreakfast?.meal.id, $0.lunch?.meal.id, $0.sideLunch?.meal.id, $0.dinner?.meal.id, $0.sideDinner?.meal.id]
            }.compactMap { $0 } // Ensure nil values are removed
        )
        
        // Select a new recipe
        guard let newRecipe = randomRecipe(from: collection, excluding: &usedRecipeIDs) else {
            print("No available recipes for the specified slot.")
            return
        }
        
        onRecieveReplaceRecipe(replaceRecipe: newRecipe)
    }
    
    /// Updates a specific meal slot in a given `DailyMeals` instance and recalculates macros and calories.
    /// - Parameters:
    ///   - dailyMeal: The `DailyMeals` instance to update.
    ///   - slot: The meal slot to update.
    ///   - newRecipe: The new recipe to assign.
    private func updateMealSlot(for dailyMeal: inout DailyMeals, slot: MealSlot.MealType, newRecipe: ProcessedRecipe) {
        // Assign the new recipe to the corresponding slot
        switch slot {
            case .breakfast:
                dailyMeal.breakfast = MealEntry(meal: newRecipe)
            case .sideBreakfast:
                dailyMeal.sideBreakfast = MealEntry(meal: newRecipe)
            case .lunch:
                dailyMeal.lunch = MealEntry(meal: newRecipe)
            case .sideLunch:
                dailyMeal.sideLunch = MealEntry(meal: newRecipe)
            case .dinner:
                dailyMeal.dinner = MealEntry(meal: newRecipe)
            case .sideDinner:
                dailyMeal.sideDinner = MealEntry(meal: newRecipe)
        }
        
        // Extract all available meal entries (filter out nil values)
        let mealEntries = [
            dailyMeal.breakfast,
            dailyMeal.sideBreakfast,
            dailyMeal.lunch,
            dailyMeal.sideLunch,
            dailyMeal.dinner,
            dailyMeal.sideDinner
        ].compactMap { $0 } // Removes nil values
        
        // Sum up calories and macros
        let totalCalories = mealEntries.reduce(0) { $0 + ($1.meal.recipe.calories) }
        let totalCarbs = mealEntries.reduce(0) { $0 + ($1.meal.recipe.macros.carbs) }
        let totalProtein = mealEntries.reduce(0) { $0 + ($1.meal.recipe.macros.protein) }
        let totalFat = mealEntries.reduce(0) { $0 + ($1.meal.recipe.macros.fat) }
        
        // Assign updated macros and calories
        dailyMeal.calories = totalCalories
        dailyMeal.macros = Macros(carbs: totalCarbs, protein: totalProtein, fat: totalFat)
    }
    
    
    /// Retrieves a random unique `ProcessedRecipe` from a given collection.
    /// - Parameters:
    ///   - collection: The `CategoryCollection` to choose a recipe from.
    ///   - excludedIDs: A `Set<String>` of IDs to avoid duplicates.
    /// - Returns: A `ProcessedRecipe` if successful, otherwise `nil`.
    func randomRecipe(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> ProcessedRecipe? {
        let availableIDs = getAvailabeRecipesForUserCookingSkill(from: collection, excluding: &excludedIDs)
        
        guard let selectedID = availableIDs.randomElement(),
              let selectedRecipe = RecipeSourceManager.shared.findRecipe(byID: selectedID) else {
            return nil
        }
        
        excludedIDs.insert(selectedID) // Mark the ID as used
        return selectedRecipe
    }
    
    func getAvailabeRecipesForUserCookingSkill(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> [String] {
        let cookingSkill = User.shared.cookingSkill
        
        if cookingSkill == .intermediate {
            return getAvailableIntermadiateRecipes(from: collection, excluding: &excludedIDs)
        }
        
        if cookingSkill == .advanced {
            return getAvailableHardRecipes(from: collection, excluding: &excludedIDs)
        }
        
        return getAvailableEasyRecipes(from: collection, excluding: &excludedIDs)
    }
    
    func getAvailableEasyRecipes(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> [String] {
        let userAvoidanceBitmask = User.shared.foodPreferenceBitMask // ✅ Assume this is the user's avoidance hex

        // ✅ 70% chance to prioritize `processedRecipesEasy`
        let prioritizeEasyFirst = Bool.random(probability: 0.7)

        let primaryList = prioritizeEasyFirst ? collection.processedRecipesEasy : collection.processedRecipesIntermediate
        let secondaryList = prioritizeEasyFirst ? collection.processedRecipesIntermediate : collection.processedRecipesEasy

        // ✅ Try the primary list first
        let primaryAvailable = primaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        if !primaryAvailable.isEmpty {
            return primaryAvailable
        }

        // ✅ If no suitable recipes in the primary list, check secondary list
        let secondaryAvailable = secondaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        return secondaryAvailable
    }
    
    func getAvailableIntermadiateRecipes(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> [String] {
        let userAvoidanceBitmask = User.shared.foodPreferenceBitMask // ✅ Assume this is the user's avoidance hex
        
        // ✅ 50% chance to prioritize `processedRecipesIntermadiate`
        let prioritizeIntermadiateFirst = Bool.random(probability: 0.7)

        let primaryList = prioritizeIntermadiateFirst ? collection.processedRecipesIntermediate : collection.processedRecipesEasy
        let secondaryList = prioritizeIntermadiateFirst ? collection.processedRecipesEasy : collection.processedRecipesIntermediate
        let tertiaryList = collection.processedRecipesHard

        // ✅ Try the primary list first
        let primaryAvailable = primaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        if !primaryAvailable.isEmpty {
            return primaryAvailable
        }

        // ✅ If no suitable recipes in the primary list, check secondary list
        let secondaryAvailable = secondaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        if !secondaryAvailable.isEmpty {
            return secondaryAvailable
        }
        
        let tertiaryAvailable = tertiaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        return tertiaryAvailable
    }
    
    func getAvailableHardRecipes(from collection: CategoryCollection, excluding excludedIDs: inout Set<String>) -> [String] {
        let userAvoidanceBitmask = User.shared.foodPreferenceBitMask // ✅ Assume this is the user's avoidance hex

        // ✅ 50% chance to prioritize `processedRecipesIntermadiate`
        let prioritizeIntermadiateFirst = Bool.random(probability: 0.7)

        let primaryList = prioritizeIntermadiateFirst ? collection.processedRecipesHard : collection.processedRecipesIntermediate
        let secondaryList = prioritizeIntermadiateFirst ? collection.processedRecipesIntermediate : collection.processedRecipesHard
        let tertiaryList = collection.processedRecipesEasy

        // ✅ Try the primary list first
        let primaryAvailable = primaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        if !primaryAvailable.isEmpty {
            return primaryAvailable
        }

        // ✅ If no suitable recipes in the primary list, check secondary list
        let secondaryAvailable = secondaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        if !secondaryAvailable.isEmpty {
            return secondaryAvailable
        }
        
        let tertiaryAvailable = tertiaryList.filter { isRecipeValid($0, userAvoidanceBitmask: userAvoidanceBitmask, excludedIDs: excludedIDs) }
        return tertiaryAvailable
    }
    
    /// ✅ **Checks if a recipe is valid (not excluded & safe for the user)**
    private func isRecipeValid(_ recipeID: String, userAvoidanceBitmask: String, excludedIDs: Set<String>) -> Bool {
        guard !excludedIDs.contains(recipeID),
              let recipeBitmask = RecipeAvoidanceOperation.extractAvoidanceBitmask(from: recipeID) else {
            return false
        }

        return RecipeAvoidanceOperation.isRecipeSafe(userAvoidanceHex: userAvoidanceBitmask, recipeHex: recipeBitmask)
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
    
    /// Updates the recipe for a specific day and slot with a provided recipe ID.
    /// - Parameters:
    ///   - date: The date for which the recipe should be updated.
    ///   - slot: The meal slot to update (e.g., breakfast, lunch).
    ///   - recipeID: The new recipe ID to assign to the specified slot.
    func updateRecipe(with recipeID: String) {
        guard var weeklyPlan = currentWeeklyPlan else {
            print("No current weekly plan found.")
            return
        }
        
        // Fetch the new recipe
        guard let newRecipe = RecipeSourceManager.shared.findRecipe(byID: recipeID) else {
            print("Failed to find recipe with ID \(recipeID)")
            return
        }
        
        guard let date = replaceMode.replacedDate else {
            print("No replacedDate found.")
            return
        }
        
        guard let slot = replaceMode.replacedSlotType else {
            print("No replacedSlotType found.")
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
    
    func generateMealsForToday() {
        let today = calendar.startOfDay(for: Date()) // Correct way to get today's date
        generateMealsForSpecificDay(for: today) // Pass the correct parameter
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
    func removeDailyMeals(for date: Date, with save: Bool = true) {
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
        
        if save {
            MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
        }
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
    
    /// Generates a weekly meal plan starting from the provided date.
    /// - Parameter startDate: The start date of the week.
    /// - Returns: A `WeeklyMeals` object containing daily meal plans for the week.
    func generateEmptyWeeklyMeals() {
        var dailyMeals: [DailyMeals] = []
        let startDate = calendar.date(byAdding: .day, value: 0, to: Date()) ?? Date()
        
        // Generate meals for 7 days
        for dayOffset in 0..<7 {
            guard let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate),
                  let dailyMeal = generateEmptyDailyMeals(for: currentDate) else {
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
    
    func generateEmptyDailyMeals(for date: Date) -> DailyMeals? {
            return DailyMeals(
                date: date,
                macros: Macros(carbs: 0, protein: 0, fat: 0),
                calories: 0,
                waterChallenge: WaterChallengeEntry(goal: 2, progress: 0)
            )
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
            
            // Extract macros and calories safely
            let recipes = [breakfast, sideBreakfast, lunch, sideLunch, dinner, sideDinner]
            
            let totalCalories = recipes.reduce(0) { $0 + ($1.recipe.calories) }
            let totalCarbs = recipes.reduce(0) { $0 + ($1.recipe.macros.carbs) }
            let totalProtein = recipes.reduce(0) { $0 + ($1.recipe.macros.protein) }
            let totalFat = recipes.reduce(0) { $0 + ($1.recipe.macros.fat) }
            
            let totalMacros = Macros(carbs: totalCarbs, protein: totalProtein, fat: totalFat)
            
            return DailyMeals(
                date: date,
                breakfast: MealEntry(meal: breakfast),
                sideBreakfast: MealEntry(meal: sideBreakfast),
                lunch: MealEntry(meal: lunch),
                sideLunch: MealEntry(meal: sideLunch),
                dinner: MealEntry(meal: dinner),
                sideDinner: MealEntry(meal: sideDinner),
                macros: totalMacros,
                calories: totalCalories,
                waterChallenge: WaterChallengeEntry(goal: 2, progress: 0)
            )
        }
        
        /// Toggles the `isEaten` status for a specific meal slot on a given date.
        /// - Parameters:
        ///   - date: The date for which the meal slot should be updated.
        ///   - slot: The meal slot to toggle.
        func toggleMealEatenStatus(for date: Date, in slot: MealSlot.MealType) {
            guard var weeklyPlan = currentWeeklyPlan else {
                print("No current weekly plan found.")
                return
            }
            
            // Find the index of the day to update
            guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
                print("No meals found for the specified date.")
                return
            }
            
            // Reference to the specific day
            var dailyMeal = weeklyPlan.dailyMeals[index]
            
            // Toggle the `isEaten` status for the correct meal slot
            switch slot {
            case .breakfast:
                dailyMeal.breakfast?.isEaten.toggle()
            case .sideBreakfast:
                dailyMeal.sideBreakfast?.isEaten.toggle()
            case .lunch:
                dailyMeal.lunch?.isEaten.toggle()
            case .sideLunch:
                dailyMeal.sideLunch?.isEaten.toggle()
            case .dinner:
                dailyMeal.dinner?.isEaten.toggle()
            case .sideDinner:
                dailyMeal.sideDinner?.isEaten.toggle()
            }
            
            // Update the weekly plan with the modified day
            weeklyPlan.dailyMeals[index] = dailyMeal
            currentWeeklyPlan = weeklyPlan
            
            // Save the updated plan
            MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
        }
        
        /// Updates water challenge progress for a specific day
        /// - Parameters:
        ///   - date: The date for which the water challenge progress should be updated.
        ///   - progress: The updated progress value.
        ///   - goal: The updated goal value.
        func updateWaterChallengeProgress(for date: Date, with progress: CGFloat, in goal: CGFloat) {
            guard var weeklyPlan = currentWeeklyPlan else {
                print("No current weekly plan found.")
                return
            }
            
            // Find the index of the day to update
            guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
                print("No meals found for the specified date.")
                return
            }
            
            // Update `waterChallenge` directly in the `weeklyPlan`
            weeklyPlan.dailyMeals[index].waterChallenge.progress = progress
            weeklyPlan.dailyMeals[index].waterChallenge.goal = goal
            
            // Assign the modified `weeklyPlan` back
            currentWeeklyPlan = weeklyPlan
            
            // Save the updated plan
            MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
        }
        
        /// Updates the water challenge goal for a specific day
        /// - Parameters:
        ///   - date: The date for which the goal should be updated.
        ///   - goal: The new goal value.
        func updateWaterChallengeGoal(for date: Date, with goal: CGFloat) {
            guard var weeklyPlan = currentWeeklyPlan else {
                print("No current weekly plan found.")
                return
            }
            
            // Find the index of the day to update
            guard let index = weeklyPlan.dailyMeals.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
                print("No meals found for the specified date.")
                return
            }
            
            // Update the water challenge goal
            weeklyPlan.dailyMeals[index].waterChallenge.goal = goal
            
            // Assign the modified `weeklyPlan` back
            currentWeeklyPlan = weeklyPlan
            
            // Save the updated plan
            MealPlanLoader.shared.saveWeeklyMeals(weeklyPlan)
            
            print("Updated water challenge goal to \(goal)L for \(date)")
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

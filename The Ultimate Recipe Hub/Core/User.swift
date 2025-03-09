//
//  User.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.12.2024.
//

import Foundation

class User: ObservableObject {
    static let shared = User()
    @Published var isFTLandingCompleted: Bool = false
    @Published var isOnBoardingCompleted: Bool = false
    @Published var isFTPlanGenerationCompleted: Bool = false
    @Published var goals: Set<Goal> = [] // Multiple selection
    @Published var cookingSkill: CookingSkill? = nil // Single selection
    @Published var foodSensitivities: Set<FoodSensitivity> = [] // Multiple selection
    @Published var subscription: RecipeModel.SubscriptionType = .free
    
    @Published var foodPreferenceBitMask: String = "0" // Single selection
    @Published var foodPreference: FoodPreference? = nil // Single selection
    
    private init() {
        loadFromUserDefaults()
    }
    
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(isFTLandingCompleted, forKey: "FTLandingCompleted")
        defaults.set(isOnBoardingCompleted, forKey: "OnboardingCompleted")
        defaults.set(isFTPlanGenerationCompleted, forKey: "FTPlanGenerationCompleted")
        
        if isOnBoardingCompleted {
            defaults.set(goals.map { $0.rawValue }, forKey: "OnboardingGoals")
            defaults.set(foodPreference?.rawValue, forKey: "OnboardingFoodPreference")
            defaults.set(cookingSkill?.rawValue, forKey: "OnboardingCookingSkill")
            defaults.set(foodSensitivities.map { $0.rawValue }, forKey: "OnboardingFoodSensitivities")
            defaults.set(foodPreferenceBitMask, forKey: "FoodSensitivitiesBitMask")
        }
    }
    
    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        isFTLandingCompleted = defaults.bool(forKey: "FTLandingCompleted")
        isOnBoardingCompleted = defaults.bool(forKey: "OnboardingCompleted")
        isFTPlanGenerationCompleted = defaults.bool(forKey: "FTPlanGenerationCompleted")
        
        if isOnBoardingCompleted {
            if let savedGoals = defaults.array(forKey: "OnboardingGoals") as? [String] {
                goals = Set(savedGoals.compactMap { Goal(rawValue: $0) })
            }
            if let savedFoodPreference = defaults.string(forKey: "OnboardingFoodPreference") {
                foodPreference = FoodPreference(rawValue: savedFoodPreference)
            }
            if let savedCookingSkill = defaults.string(forKey: "OnboardingCookingSkill") {
                cookingSkill = CookingSkill(rawValue: savedCookingSkill)
            }
            if let savedSensitivities = defaults.array(forKey: "OnboardingFoodSensitivities") as? [String] {
                foodSensitivities = Set(savedSensitivities.compactMap { FoodSensitivity(rawValue: $0) })
            }
            if let sensitivitiesBitMask = defaults.string(forKey: "FoodSensitivitiesBitMask") {
                foodPreferenceBitMask = sensitivitiesBitMask
            }
        }
    }
    
    func logUserSelections() {
        // Log the user's goals
        if !goals.isEmpty {
            print("User Goals: \(goals.map { $0.rawValue }.joined(separator: ", "))")
        } else {
            print("User Goals: None")
        }
        
        // Log the user's food preference
        if let preference = foodPreference {
            print("User Food Preference: \(preference.rawValue)")
        } else {
            print("User Food Preference: None")
        }
        
        // Log the user's cooking skill
        if let skill = cookingSkill {
            print("User Cooking Skill: \(skill.rawValue)")
        } else {
            print("User Cooking Skill: None")
        }
        
        // Log the user's food sensitivities
        if !foodSensitivities.isEmpty {
            print("User Food Sensitivities: \(foodSensitivities.map { $0.rawValue }.joined(separator: ", "))")
        } else {
            print("User Food Sensitivities: None")
        }
    }
    
    func resetPreferences() {
        foodSensitivities = []
        foodPreference = nil
    }
    
    func resetCookingSkill() {
        cookingSkill = nil
    }
    
    // Helper Methods for Goals
    func toggleGoal(_ goal: Goal) {
        
        if goal == Goal.none {
            goals.removeAll()
        }
        
        if goals.contains(goal) {
            goals.remove(goal)
        } else {
            goals.insert(goal)
        }
    }
    
    func selectFoodPreference(_ preference: FoodPreference) {
        foodPreference = preference
        validateFoodSensitivities()
    }
    
    func getAvoidanceList() -> [FoodSensitivity] {
        guard let preference = foodPreference else { return [] }
        
        switch preference {
        case .vegetarian:
            return [.avoidMeat, .avoidSeafood, .avoidChicken, .avoidPork]
        case .vegan:
            return [.avoidMeat, .avoidSeafood, .avoidChicken, .avoidPork, .avoidEgg, .avoidDairy]
        case .pescatarian:
            return [.avoidMeat, .avoidChicken, .avoidPork]
        case .halal:
            return [.avoidPork, .avoidAlcohol]
        case .glutenFree:
            return [.avoidGrains]
        default:
            return []
        }
    }
    
    func getAvoidanceLimit() -> Int {
        guard let preference = foodPreference else { return 4 }
        
        switch preference {
            case .flexible:
                return 4
            case .vegetarian:
                return 2
            case .vegan:
                return 1
            case .halal:
                return 3
            case .glutenFree:
                return 3
            case .pescatarian:
                return 2
            case .lowCarb:
                return 4
            }
        
    }
    
    func validateFoodSensitivities() {
        
        foodSensitivities.removeAll()
        
        foodSensitivities.formUnion(getAvoidanceList())
    }
    
    // Helper Methods for Cooking Skills
    func selectCookingSkill(_ skill: CookingSkill) {
        cookingSkill = skill
    }
    
    // Helper Methods for Food Sensitivities
    func toggleFoodSensitivity(_ sensitivity: FoodSensitivity) {
        if foodSensitivities.contains(sensitivity) {
            foodSensitivities.remove(sensitivity)
        } else {
            foodSensitivities.insert(sensitivity)
        }
    }
    
    func setOnboardingAsComplete() {
        if !isOnBoardingCompleted {
            isOnBoardingCompleted = true
            foodPreferenceBitMask = RecipeAvoidanceOperation.encodeAvoidance(foodSensitivities)
            print(foodPreferenceBitMask)
            saveToUserDefaults()
        }
    }
    
    func setFTLandingAsComplete() {
        if !isFTLandingCompleted {
            isFTLandingCompleted = true
            saveToUserDefaults()
        }
    }
    
    func setFTPlanGenerationComplete() {
        if !isFTPlanGenerationCompleted {
            isFTPlanGenerationCompleted = true
            saveToUserDefaults()
        }
    }
}

extension Bool {
    /// ✅ Returns `true` with the given probability (e.g., `0.7` means 70% `true`).
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0...1) < probability
    }
}

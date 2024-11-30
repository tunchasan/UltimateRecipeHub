//
//  User.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.12.2024.
//

import Foundation

class User: ObservableObject {
    static let shared = User()
    
    @Published var isOnBoardingCompleted: Bool = false
    @Published var goals: Set<Goal> = [] // Multiple selection
    @Published var foodPreference: FoodPreference? = nil // Single selection
    @Published var cookingSkill: CookingSkill? = nil // Single selection
    @Published var foodSensitivities: Set<FoodSensitivity> = [] // Multiple selection
    
    private init() {
        loadFromUserDefaults()
    }
    
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(isOnBoardingCompleted, forKey: "OnboardingCompleted")
        
        if isOnBoardingCompleted {
            defaults.set(goals.map { $0.rawValue }, forKey: "OnboardingGoals")
            defaults.set(foodPreference?.rawValue, forKey: "OnboardingFoodPreference")
            defaults.set(cookingSkill?.rawValue, forKey: "OnboardingCookingSkill")
            defaults.set(foodSensitivities.map { $0.rawValue }, forKey: "OnboardingFoodSensitivities")
        }
    }
    
    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        isOnBoardingCompleted = defaults.bool(forKey: "OnboardingCompleted")
        
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
    
    
    func resetData() {
        goals = []
        foodPreference = nil
        cookingSkill = nil
        foodSensitivities = []
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
            return [.avoidPork]
        default:
            return []
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
    
    func setOnboardingAsComplete(){
        isOnBoardingCompleted = true
        saveToUserDefaults()
    }
}

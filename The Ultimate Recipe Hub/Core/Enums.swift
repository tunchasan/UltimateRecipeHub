//
//  Enums.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.12.2024.
//

import Foundation

enum Goal: String, CaseIterable {
    case loseWeight = "Lose Weight"
    case maintainWeight = "Maintain Weight"
    case gainWeight = "Gain Weight"
    case eatHealthy = "Eat Healthy"
    case saveMoney = "Save Money"
    case planWeeklyMeals = "Plan Weekly Meals"
    case buildHealthierHabits = "Build Healthier Habits"
    case none = "None"
}

enum FoodPreference: String, CaseIterable {
    case flexible = "Flexible"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case halal = "Halal"
    case glutenFree = "Gluten Free"
    case pescatarian = "Pescatarian"
    case lowCarb = "Low Keto"
}

enum CookingSkill: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum FoodSensitivity: String, CaseIterable {
    case avoidChicken = "Avoid Chicken"
    case avoidMeat = "Avoid Meat"
    case avoidSeafood = "Avoid Seafood"
    case avoidNuts = "Avoid Nuts"
    case avoidPork = "Avoid Pork"
    case avoidDairy = "Avoid Dairy"
    case avoidGrains = "Avoid Grains"
    case avoidEgg = "Avoid Egg"
    case avoidSpice = "Avoid Spice"
    case avoidFruit = "Avoid Fruit"
}

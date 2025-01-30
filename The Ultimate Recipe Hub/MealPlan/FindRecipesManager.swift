//
//  FindRecipesManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.01.2025.
//

import SwiftUI
import Combine

class FindRecipesManager: ObservableObject {
    // Singleton instance
    static let shared = FindRecipesManager()
    
    // Published variables to track the state
    @Published var selectedDate: Date? = nil
    @Published var selectedSlot: MealSlot.MealType? = nil
    @Published var categoryCollection: CategoryCollection? = nil
    @Published var excludeRecipe: ProcessedRecipe? = nil
    @Published var isFindingRecipes: Bool = false

    private init() {}

    /// Triggers the process of finding suitable recipes for a given slot.
    /// - Parameters:
    ///   - date: The date for which the meal is planned.
    ///   - slot: The meal slot type.
    ///   - excludeId: The ID to exclude from the collection.
    func startFindingRecipes(for date: Date, slot: MealSlot.MealType, excludeRecipe: ProcessedRecipe?) {
        print(slot)
        self.selectedDate = date
        self.selectedSlot = slot
        self.excludeRecipe = excludeRecipe
        self.isFindingRecipes = true
        self.categoryCollection = MealPlanCollectionLoader.shared.getCollection(byType: slot.collectionType)
    }

    /// Clears the state when the process is done or dismissed.
    func clear() {
        self.excludeRecipe = nil
        self.selectedDate = nil
        self.selectedSlot = nil
        self.categoryCollection = nil
        self.isFindingRecipes = false
    }
}

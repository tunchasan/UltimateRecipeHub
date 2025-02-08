//
//  CollectionDetailsView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.01.2025.
//

import SwiftUI

struct FindSuitableRecipesView: View {
    var date: Date
    var slot: MealSlot.MealType
    var categoryCollection: CategoryCollection

    private let gridColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @Environment(\.presentationMode) var presentationMode // Add this line

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 30) {
                ForEach(RecipeSourceManager.shared.resolveRecipes(for: categoryCollection)) { processedRecipe in
                    RecipeCard(
                        model: processedRecipe,
                        canNavigateTo: false
                    ) {
                        let recipe = FindRecipesManager.shared.excludeRecipe
                        MealPlanManager.shared.onRecieveReplaceRecipe(replaceRecipe: processedRecipe)
                        MealPlanManager.shared.onRecieveReplacedRecipe(replacedRecipe: recipe!, replacedSlot: slot, replacedDate: date)
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
                }
            }
            .padding(.top, 25)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(slot.displayName)
        .onDisappear {
            FindRecipesManager.shared.clear()
            TabVisibilityManager.showTabBar()
        }
        .onAppear {
            TabVisibilityManager.hideTabBar()
        }
    }
}

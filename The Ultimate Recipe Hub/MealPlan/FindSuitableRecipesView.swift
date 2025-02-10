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
    @State var openReplaceView: Bool = false
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 30) {
                
                // Resolve recipes & filter out excluded ones
                let filteredRecipes = RecipeSourceManager.shared.resolveRecipes(for: categoryCollection)
                    .filter { FindRecipesManager.shared.excludeRecipe?.id != $0.id }
                    .sorted {
                        // Sort favorited recipes to the top
                        FavoriteRecipesManager.shared.isFavorited(recipeID: $0.id) &&
                        !FavoriteRecipesManager.shared.isFavorited(recipeID: $1.id)
                    }

                ForEach(filteredRecipes) { processedRecipe in
                    
                    let isFavoriRecipe = FavoriteRecipesManager.shared.isFavorited(recipeID: processedRecipe.id)
                    
                    RecipeCard(
                        model: processedRecipe,
                        showFavoriteButton: isFavoriRecipe,
                        isFavoriteButtonFunctional: false,
                        canNavigateTo: false
                    ) {
                        if let recipe = FindRecipesManager.shared.excludeRecipe {
                            mealPlanManager.onRecieveReplaceRecipe(replaceRecipe: processedRecipe)
                            mealPlanManager.onRecieveReplacedRecipe(replacedRecipe: recipe, replacedSlot: slot, replacedDate: date)
                        } else {
                            mealPlanManager.updateRecipe(for: date, in: slot, with: processedRecipe.id)
                            presentationMode.wrappedValue.dismiss()
                        }
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
            mealPlanManager.clearReplaceMode()
            FindRecipesManager.shared.clear()
            TabVisibilityManager.showTabBar()
        }
        .onAppear {
            TabVisibilityManager.hideTabBar()
        }
        .onReceive(mealPlanManager.onHandleReplaceMode) { newMode in
            openReplaceView = true
        }
        .onReceive(mealPlanManager.onCompleteReplaceMode) {
            presentationMode.wrappedValue.dismiss()
        }
        .sheet(isPresented: $openReplaceView) {
            ReplaceRecipe()
        }
    }
}

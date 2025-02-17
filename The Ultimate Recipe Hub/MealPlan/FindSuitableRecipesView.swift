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
    @State var hasReplacedRecipe: Bool = false
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
                    
                    let excludeRecipe = FindRecipesManager.shared.excludeRecipe
                    
                    // Only redirect for empty slot assigning
                    let isNavigatable = DirectionState.determine() == .emptySlot
                    let isDirectedFindSuitableRecipes = DirectionState.determine() == .emptySlot
                    
                    let isFavoriRecipe = FavoriteRecipesManager.shared.isFavorited(recipeID: processedRecipe.id)
                    
                    RecipeCard(
                        model: processedRecipe,
                        showFavoriteButton: isFavoriRecipe,
                        isFavoriteButtonFunctional: false,
                        canNavigateTo: isNavigatable,
                        isDirectedFindSuitableRecipes: isDirectedFindSuitableRecipes,
                        isCookingModeEnableInDetails: false,
                        isShoppingToolbarButtonEnabled: false,
                        action: {
                            if let recipe = excludeRecipe {
                                mealPlanManager.onRecieveReplaceRecipe(replaceRecipe: processedRecipe)
                                mealPlanManager.onRecieveReplacedRecipe(replacedRecipe: recipe)
                            }
                        },
                        onClickAddToMealPlan: {
                            hasReplacedRecipe = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
            .padding(.top, 25)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(slot.displayName)
        .onDisappear {
            handleReplacingMode(
                with: false,
                flag: DirectionState.determine() == .filledSlot || hasReplacedRecipe
            )
        }
        .onAppear {
            mealPlanManager.onUpdateReplaceMode(
                replaceDate: date,
                replacedSlot: slot
            )
            
            TabVisibilityManager.hideTabBar()
        }
        .onReceive(mealPlanManager.onHandleReplaceMode) { newMode in
            openReplaceView = true
        }
        .onReceive(mealPlanManager.onCompleteReplaceMode) {
            handleReplacingMode(
                with: true,
                flag: DirectionState.determine() == .emptySlot
            )
        }
        .sheet(isPresented: $openReplaceView) {
            ReplaceRecipe()
        }
    }
    
    func handleReplacingMode(with dismiss: Bool, flag clear: Bool) {
        
        if dismiss {
            presentationMode.wrappedValue.dismiss()
            print("dismiss")
        }
        
        if clear {
            mealPlanManager.clearReplaceMode()
            FindRecipesManager.shared.clear()
            TabVisibilityManager.showTabBar()
            print("clear")
        }
    }
}

enum DirectionState {
    case emptySlot
    case filledSlot
    
    /// Determines if the `excludeRecipe` is set or not.
    /// - Returns: A `DirectionState` case indicating if the slot is empty or filled.
    static func determine() -> DirectionState {
        if FindRecipesManager.shared.excludeRecipe != nil {
            return .filledSlot
        }
        return .emptySlot
    }
}

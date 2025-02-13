//
//  EmptyRecipeSlot.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct EmptyRecipeSlot: View {
    var title: String
    var date: Date
    var slot: MealSlot.MealType
    var isReplaceMode: Bool = false
    var mealPlanner = MealPlanManager.shared

    var body: some View {
        Button(
            action: {
                if isReplaceMode {
                    
                    guard let recipeId = mealPlanner.replaceMode.replaceRecipe?.id else {
                        print("Failed to find recipe with ID")
                        return
                    }
                    
                    mealPlanner.updateRecipe(
                        for: date,
                        in: slot,
                        with: recipeId
                    )
                    
                    mealPlanner.clearReplaceMode()
                    mealPlanner.completeReplaceMode()
                    mealPlanner.incrementUpdatesCount()
            }
            
            else {
                FindRecipesManager.shared.startFindingRecipes(
                    for: date,
                    slot: slot,
                    excludeRecipe: nil
                )
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: "plus")
                    .font(.system(size: 40))
                    .foregroundColor(.green.opacity(0.7))
                
                Image("Test1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 235) // Size of the button
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(0.1)
                
                Text(title)
                    .font(.system(size: 14).bold())
                    .foregroundColor(.gray)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(Color.clear) // Prevents touch passing through
            .contentShape(Rectangle()) // Ensures only this view is tappable
        }
        .buttonStyle(PlainButtonStyle()) // Removes extra padding
        .frame(width: 170, height: 235) // Ensures correct sizing
    }
}

struct EmptyRecipeSlot_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRecipeSlot(title: "Breakfast", date: Date(), slot: .breakfast)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

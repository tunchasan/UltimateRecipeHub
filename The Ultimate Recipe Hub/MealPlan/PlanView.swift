//
//  PlanView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI

struct PlanView: View {
    @StateObject private var mealPlanManager = MealPlanManager.shared
    @StateObject private var findRecipesManager = FindRecipesManager.shared // Add FindRecipesManager

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    if let weeklyMeals = mealPlanManager.currentWeeklyPlan {
                        // Sort meals so past days appear at the end, excluding today
                        let sortedMeals = weeklyMeals.dailyMeals.sorted { meal1, meal2 in
                            let now = Date()
                            let calendar = Calendar.current
                            
                            let isMeal1Past = meal1.date < now && !calendar.isDateInToday(meal1.date)
                            let isMeal2Past = meal2.date < now && !calendar.isDateInToday(meal2.date)
                            
                            if isMeal1Past && isMeal2Past {
                                return meal1.date < meal2.date // Keep past days in chronological order
                            } else if isMeal1Past {
                                return false // Past days come after current and future days
                            } else if isMeal2Past {
                                return true // Current and future days come first
                            } else {
                                return meal1.date < meal2.date // Keep current and future days in chronological order
                            }
                        }
                        
                        ForEach(sortedMeals, id: \.date) { dailyMeal in
                            PlanDayView(
                                date: dailyMeal.date,
                                isToday: Calendar.current.isDateInToday(dailyMeal.date),
                                isPast: dailyMeal.date < Date() && !Calendar.current.isDateInToday(dailyMeal.date),
                                mealSlots: generateMealSlots(from: dailyMeal)
                            )
                        }
                    } else {
                        Text("Generating weekly meal plan...")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("Meal Plan")
            .toolbar {
                PlanPageMenuButton(systemImageName: "ellipsis")
            }
            .navigationDestination(
                isPresented: $findRecipesManager.isFindingRecipes,
                destination: {
                    if let date = findRecipesManager.selectedDate,
                       let slot = findRecipesManager.selectedSlot,
                       let categoryCollection = findRecipesManager.categoryCollection {
                        FindSuitableRecipesView(
                            date: date,
                            excludeId: findRecipesManager.excludeId,
                            slot: slot,
                            categoryCollection: categoryCollection
                        )
                    } else {
                        Text("No recipes found for the selected slot.")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            )
        }
    }
    
    /// Generates meal slots from the `DailyMeals` object.
    /// - Parameter dailyMeal: The `DailyMeals` object.
    /// - Returns: An array of `MealSlot` objects.
    private func generateMealSlots(from dailyMeals: DailyMeals) -> [MealSlot] {
        return [
            MealSlot(id: dailyMeals.breakfast, type: .breakfast, isFilled: !dailyMeals.breakfast.isEmpty),
            MealSlot(id: dailyMeals.sideBreakfast, type: .sideBreakfast, isFilled: !dailyMeals.sideBreakfast.isEmpty),
            MealSlot(id: dailyMeals.lunch, type: .lunch, isFilled: !dailyMeals.lunch.isEmpty),
            MealSlot(id: dailyMeals.sideLunch, type: .sideLunch, isFilled: !dailyMeals.sideLunch.isEmpty),
            MealSlot(id: dailyMeals.dinner, type: .dinner, isFilled: !dailyMeals.dinner.isEmpty),
            MealSlot(id: dailyMeals.sideDinner, type: .sideDinner, isFilled: !dailyMeals.sideDinner.isEmpty)
        ]
    }
}

struct PlanPageMenuButton: View {
    var systemImageName: String
    var systemImageColor: Color = .green
    var size: CGFloat = 30
    
    var body: some View {
        Menu {
            Button {
                print("Add to Groceries tapped")
            } label: {
                Label("Add to Groceries", systemImage: "cart.fill")
            }
            Button {
                print("Generate Plan for Week tapped")
                MealPlanManager.shared.generateWeeklyMeals()
            } label: {
                Label("Generate Plan for Week", systemImage: "calendar")
            }
            Button(role: .destructive) {
                print("Clear Current Week tapped")
                MealPlanManager.shared.removeWeeklyMeals()
            } label: {
                Label("Clear Current Week", systemImage: "trash")
            }
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.5).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

struct RecipePlanCardMenuButton: View {
    var systemImageName: String
    var systemImageColor: Color = .green
    var size: CGFloat = 30
    
    var body: some View {
        Menu {
            Button {
                print("Swap")
            } label: {
                Label("Swap", systemImage: "repeat")
            }
            Button {
                print("Eaten")
            } label: {
                Label("Eaten", systemImage: "checkmark")
            }
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.6).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}

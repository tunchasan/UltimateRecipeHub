//
//  PlanView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI

struct PlanView: View {
    var isReplaceMode: Bool = false
    @State private var isVisible = false
    @State var openReplaceView: Bool = false
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    @ObservedObject private var findRecipesManager = FindRecipesManager.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    if let weeklyMeals = mealPlanManager.currentWeeklyPlan {
                        // Sort meals and optionally filter out past days
                        let filteredMeals = weeklyMeals.dailyMeals
                            .filter { !isReplaceMode || !($0.date < Date() && !Calendar.current.isDateInToday($0.date)) }
                            .sorted { meal1, meal2 in
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
                                                
                        ForEach(filteredMeals, id: \.date) { dailyMeal in
                            PlanDayView(
                                plan: dailyMeal,
                                isToday: Calendar.current.isDateInToday(dailyMeal.date),
                                isPast: dailyMeal.date < Date() && !Calendar.current.isDateInToday(dailyMeal.date),
                                mealSlots: generateMealSlots(from: dailyMeal),
                                isReplaceMode: isReplaceMode,
                                isExpanded: Calendar.current.isDateInToday(dailyMeal.date) || isReplaceMode
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
            .navigationTitle(isReplaceMode ? "Your Plan" : "Meal Plan")
            .navigationBarTitleDisplayMode(isReplaceMode ? .inline : .automatic)
            .toolbar {
                if !isReplaceMode {
                    PlanPageMenuButton(systemImageName: "ellipsis")
                }
            }
            .navigationDestination(
                isPresented: $findRecipesManager.isFindingRecipes,
                destination: {
                    if let date = findRecipesManager.selectedDate,
                       let slot = findRecipesManager.selectedSlot,
                       let categoryCollection = findRecipesManager.categoryCollection {
                        FindSuitableRecipesView(
                            date: date,
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
            .onReceive(mealPlanManager.onHandleReplaceMode) { newMode in
                if isVisible {
                    openReplaceView = true
                }
            }
            .onReceive(mealPlanManager.onCompleteReplaceMode) {
                if isReplaceMode && isVisible {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .sheet(isPresented: $openReplaceView, onDismiss: {
                mealPlanManager.clearReplacedRecipe()
            }) {
                ReplaceRecipe()
            }
            .onAppear {
                isVisible = true

                if !isReplaceMode {
                    mealPlanManager.clearUpdatesCount()
                }
            }
            .onDisappear(perform: {
                isVisible = false
            })
        }
    }
    
    /// Generates meal slots from the `DailyMeals` object.
    /// - Parameter dailyMeal: The `DailyMeals` object.
    /// - Returns: An array of `MealSlot` objects.
    /// Generates meal slots from the `DailyMeals` object.
    /// - Parameter dailyMeal: The `DailyMeals` object.
    /// - Returns: An array of `MealSlot` objects.
    private func generateMealSlots(from dailyMeals: DailyMeals) -> [MealSlot] {        
        return [
            MealSlot(
                id: "breakfast_\(String(describing: dailyMeals.breakfast?.meal.id))",
                type: .breakfast,
                mealEntry: dailyMeals.breakfast
            ),
            
            MealSlot(
                id: "sideBreakfast_\(String(describing: dailyMeals.sideBreakfast?.meal.id))",
                type: .sideBreakfast,
                mealEntry: dailyMeals.sideBreakfast
            ),
            
            MealSlot(
                id: "lunch_\(String(describing: dailyMeals.lunch?.meal.id))",
                type: .lunch,
                mealEntry: dailyMeals.lunch
            ),
            
            MealSlot(
                id: "sideLunch_\(String(describing: dailyMeals.sideLunch?.meal.id))",
                type: .sideLunch,
                mealEntry: dailyMeals.sideLunch
            ),
            
            MealSlot(
                id: "dinner_\(String(describing: dailyMeals.dinner?.meal.id))",
                type: .dinner,
                mealEntry: dailyMeals.dinner
            ),
            
            MealSlot(
                id: "sideDinner_\(String(describing: dailyMeals.sideDinner?.meal.id))",
                type: .sideDinner,
                mealEntry: dailyMeals.sideDinner
            )
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

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}

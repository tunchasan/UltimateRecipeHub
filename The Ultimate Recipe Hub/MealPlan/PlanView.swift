//
//  PlanView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI

struct PlanView: View {
    var isReplaceMode: Bool = false
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
                                isReplaceMode: isReplaceMode
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
            .sheet(isPresented: $mealPlanManager.replaceMode.isEnabled, onDismiss: {
                mealPlanManager.clearReplacedRecipe()
            }) {
                ReplaceRecipe()
            }
            .onChange(of: mealPlanManager.replaceMode.hasReplaced) { oldValue, newValue in
                if newValue == true && isReplaceMode {
                    mealPlanManager.clearReplaceMode()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onAppear {
                if !isReplaceMode {
                    mealPlanManager.clearUpdatesCount()
                }
            }
        }
    }
    
    /// Generates meal slots from the `DailyMeals` object.
    /// - Parameter dailyMeal: The `DailyMeals` object.
    /// - Returns: An array of `MealSlot` objects.
    /// Generates meal slots from the `DailyMeals` object.
    /// - Parameter dailyMeal: The `DailyMeals` object.
    /// - Returns: An array of `MealSlot` objects.
    private func generateMealSlots(from dailyMeals: DailyMeals) -> [MealSlot] {
        let dayIdentifier = Calendar.current.component(.day, from: dailyMeals.date) // Unique ID per day
        
        return [
            MealSlot(
                id: dailyMeals.breakfast?.id ?? "breakfast_\(dayIdentifier)",
                type: .breakfast,
                recipe: dailyMeals.breakfast
            ),
            
            MealSlot(
                id: dailyMeals.sideBreakfast?.id ?? "sideBreakfast_\(dayIdentifier)",
                type: .sideBreakfast,
                recipe: dailyMeals.sideBreakfast
            ),
            
            MealSlot(
                id: dailyMeals.lunch?.id ?? "lunch_\(dayIdentifier)",
                type: .lunch,
                recipe: dailyMeals.lunch
            ),
            
            MealSlot(
                id: dailyMeals.sideLunch?.id ?? "sideLunch_\(dayIdentifier)",
                type: .sideLunch,
                recipe: dailyMeals.sideLunch
            ),
            
            MealSlot(
                id: dailyMeals.dinner?.id ?? "dinner_\(dayIdentifier)",
                type: .dinner,
                recipe: dailyMeals.dinner
            ),
            
            MealSlot(
                id: dailyMeals.sideDinner?.id ?? "sideDinner_\(dayIdentifier)",
                type: .sideDinner,
                recipe: dailyMeals.sideDinner
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

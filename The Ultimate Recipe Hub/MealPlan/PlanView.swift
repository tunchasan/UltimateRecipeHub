//
//  PlanView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI

struct PlanView: View {
    @State private var weeklyMeals: WeeklyMeals? = nil
    private let startDate = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    if let weeklyMeals = weeklyMeals {
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
                                day: formattedDay(for: dailyMeal.date),
                                date: formattedDate(for: dailyMeal.date),
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
            .onAppear {
                generateWeeklyMeals()
            }
        }
    }
    
    /// Generates the weekly meal plan.
    private func generateWeeklyMeals() {
        DispatchQueue.global(qos: .userInitiated).async {
            let generatedWeeklyMeals = MealPlanManager.shared.generateWeeklyMeals(startingFrom: startDate)
            DispatchQueue.main.async {
                self.weeklyMeals = generatedWeeklyMeals
            }
        }
    }
    
    /// Generates meal slots from the `DailyMeals` object.
    /// - Parameter dailyMeal: The `DailyMeals` object.
    /// - Returns: An array of `MealSlot` objects.
    private func generateMealSlots(from dailyMeal: DailyMeals) -> [MealSlot] {
        return [
            MealSlot(id: dailyMeal.breakfast, type: .breakfast, isFilled: true),
            MealSlot(id: dailyMeal.sideBreakfast, type: .sideBreakfast, isFilled: true),
            MealSlot(id: dailyMeal.lunch, type: .lunch, isFilled: true),
            MealSlot(id: dailyMeal.sideLunch, type: .sideLunch, isFilled: true),
            MealSlot(id: dailyMeal.dinner, type: .dinner, isFilled: true),
            MealSlot(id: dailyMeal.sideDinner, type: .sideDinner, isFilled: true)
        ]
    }
    
    /// Formats a date into a day of the week (e.g., "Monday").
    /// - Parameter date: The `Date` to format.
    /// - Returns: A string representing the day of the week.
    private func formattedDay(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    /// Formats a date into a readable string (e.g., "Dec 16").
    /// - Parameter date: The `Date` to format.
    /// - Returns: A string representing the date.
    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
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
            } label: {
                Label("Generate Plan for Week", systemImage: "calendar")
            }
            Button(role: .destructive) {
                print("Clear Current Week tapped")
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

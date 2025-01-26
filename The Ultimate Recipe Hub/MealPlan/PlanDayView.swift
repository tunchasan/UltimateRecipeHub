//
//  PlanDayView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct PlanDayView: View {
    var date: Date
    var isToday: Bool = false
    var isPast: Bool = false
    var mealSlots: [MealSlot]
    var cornerRadius: CGFloat = 12
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            headerSection
            
            if isExpanded {
                expandedContent
                    .padding(.bottom, 20)
                    .animation(.easeInOut(duration: 0.5), value: isExpanded)
            }
        }
        .background(.white)
        .cornerRadius(cornerRadius)
        .shadow(radius: 3, x: 1, y: 2)
        .padding(.horizontal, 10)
        .onAppear {
            withAnimation {
                isExpanded = isToday
            }
        }
    }
    
    private var headerSection: some View {
        ZStack {
            HStack {
                Text(formattedDay(for: date))
                    .font(.system(size: 18).bold())
                
                Text(formattedDate(for: date))
                    .font(.system(size: 16).bold())
                    .foregroundStyle(.gray)
                
                Spacer()
                
                if !isPast {
                    headerButtons
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(isPast ? .gray.opacity(0.2) : .green.opacity(0.15))
            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        }
    }
    
    private var headerButtons: some View {
        HStack(spacing: 10) {
            if !allSlotsFilled {
                IconButton(
                    systemImageName: "calendar.badge.plus",
                    systemImageColor: .green,
                    action: {
                        withAnimation {
                            MealPlanManager.shared.generateMealsForSpecificDay(for: date)
                        }
                    }
                )
            }
            IconButton(
                systemImageName: "cart.fill",
                systemImageColor: .green,
                action: {}
            )
            
            if !areAllSlotsNotFilled {
                IconButton(
                    systemImageName: "trash",
                    systemImageColor: .red,
                    action: {
                        withAnimation {
                            MealPlanManager.shared.removeDailyMeals(for: date)
                        }
                    }
                )
            }
        }
    }
    
    private var expandedContent: some View {
        VStack(spacing: 5) {
            NutritionalInfoView()
            
            LazyVStack(spacing: 20) {
                // Break mealSlots into rows of two
                ForEach(mealSlots.chunked(into: 2), id: \.self) { slotRow in
                    HStack(spacing: 20) {
                        ForEach(slotRow, id: \.id) { slot in
                            createSlotView(for: slot)
                        }
                    }
                }
            }
            .scaleEffect(0.95)
            
            if isToday {
                WaterChallengeView()
                    .padding(.top, 5)
            }
        }
    }
    
    private func createSlotView(for slot: MealSlot) -> some View {
        Group {
            if slot.isFilled {
                if let recipe = RecipeSourceManager.shared.findRecipe(byID: slot.id) {
                    RecipePlanCard(
                        date: date,
                        model: recipe,
                        slot: slot.type,
                        isActionable: !isPast
                    )
                } else {
                    EmptyRecipeSlot(title: slot.type.displayName) {}
                }
            } else {
                EmptyRecipeSlot(title: slot.type.displayName) {}
            }
        }
    }
    
    private var allSlotsFilled: Bool {
        mealSlots.allSatisfy { $0.isFilled }
    }
    
    private var areAllSlotsNotFilled: Bool {
        mealSlots.allSatisfy { !$0.isFilled }
    }
    
    /// Formats a date into a day string (e.g., "Monday").
    /// - Parameter date: The date to format.
    /// - Returns: A string representing the day of the week.
    private func formattedDay(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    /// Formats a date into a short date string (e.g., "Jan 24").
    /// - Parameter date: The date to format.
    /// - Returns: A string representing the formatted date.
    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
}

struct MealSlot: Identifiable, Hashable {
    let id: String // Recipe ID
    let type: MealType
    var isFilled: Bool
    
    enum MealType: String {
        case breakfast
        case sideBreakfast
        case lunch
        case sideLunch
        case dinner
        case sideDinner
        
        /// Returns a unified display name for meal types.
        var displayName: String {
            switch self {
            case .breakfast, .sideBreakfast:
                return "Breakfast"
            case .lunch, .sideLunch:
                return "Lunch"
            case .dinner, .sideDinner:
                return "Dinner"
            }
        }
    }
}

struct PlanDayView_Previews: PreviewProvider {
    static var previews: some View {
        // Safely unwrap the generated daily meals
        let dailyMeals = MealPlanManager.shared.generateDailyMeals(for: Date()) ?? DailyMeals(
            date: Date(),
            
            breakfast: "",
            sideBreakfast: "",
            lunch: "",
            sideLunch: "",
            dinner: "",
            sideDinner: "",
            macros: Macros(carbs: 0, protein: 0, fat: 0),
            calories: 0
        )
        
        // Create meal slots based on the unwrapped dailyMeals object
        let mealSlots = [
            MealSlot(id: dailyMeals.breakfast, type: .breakfast, isFilled: !dailyMeals.breakfast.isEmpty),
            MealSlot(id: dailyMeals.sideBreakfast, type: .sideBreakfast, isFilled: !dailyMeals.sideBreakfast.isEmpty),
            MealSlot(id: dailyMeals.lunch, type: .lunch, isFilled: !dailyMeals.lunch.isEmpty),
            MealSlot(id: dailyMeals.sideLunch, type: .sideLunch, isFilled: !dailyMeals.sideLunch.isEmpty),
            MealSlot(id: dailyMeals.dinner, type: .dinner, isFilled: !dailyMeals.dinner.isEmpty),
            MealSlot(id: dailyMeals.sideDinner, type: .sideDinner, isFilled: !dailyMeals.sideDinner.isEmpty)
        ]
        
        return PlanDayView(
            date: Date(),
            isToday: true,
            isPast: false,
            mealSlots: mealSlots
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

//
//  PlanDayView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct PlanDayView: View {
    var plan: DailyMeals
    var isToday: Bool = false
    var isPast: Bool = false
    var mealSlots: [MealSlot]
    var cornerRadius: CGFloat = 12
    var isReplaceMode: Bool = false
    @State var isExpanded: Bool = false
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    
    var body: some View {
        VStack {
            headerSection
            
            if isExpanded {
                expandedContent
                    .animation(.easeInOut(duration: 0.5), value: isExpanded)
            }
        }
        .background(.white)
        .cornerRadius(cornerRadius)
        .shadow(radius: 3, x: 1, y: 2)
        .padding(.horizontal, 10)
    }
    
    private var headerSection: some View {
        ZStack {
            HStack {
                Text(formattedDay(for: plan.date))
                    .font(.system(size: 18).bold())
                
                Text(formattedDate(for: plan.date))
                    .font(.system(size: 16).bold())
                    .foregroundStyle(.gray)
                
                Spacer()
                
                if !isPast && !isReplaceMode && isExpanded {
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
                            mealPlanManager.generateMealsForSpecificDay(for: plan.date)
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
                            mealPlanManager.removeDailyMeals(for: plan.date)
                        }
                    }
                )
            }
        }
    }
    
    private var expandedContent: some View {
        VStack(spacing: 5) {
            
            if !isReplaceMode && !plan.isEmpty() {
                NutritionalInfoView(
                    macros: plan.macros,
                    calories: plan.calories
                )
            }
            
            LazyVStack(spacing: 20) {
                ForEach(mealSlots.chunked(into: 2), id: \.self) { slotRow in
                    HStack(spacing: isReplaceMode ? 16 : 20) {
                        ForEach(slotRow, id: \.id) { slot in
                            createSlotView(for: slot)
                        }
                    }
                }
            }
            .scaleEffect(isReplaceMode ? 0.98 : 0.96)
            .padding(.bottom, 10)
            
            if isToday && !isReplaceMode {
                WaterChallengeView()
                    .padding(.bottom, 20)
            }
        }
        .padding(.top, plan.isEmpty() ? -10 : 0)
    }
    
    private func createSlotView(for slot: MealSlot) -> some View {
        ZStack {
            if slot.isFilled {
                if let recipe = slot.mealEntry?.meal {
                    RecipePlanCard(
                        date: plan.date,
                        
                        model: recipe,
                        slot: slot.type,
                        
                        isActionable: !isPast,
                        isReplaceMode: isReplaceMode,
                        
                        isPro: slot.isPro,
                        isEaten: slot.isEaten
                    )
                } else {
                    EmptyRecipeSlot(
                        title: slot.type.displayName,
                        date: plan.date,
                        slot: slot.type,
                        isReplaceMode: isReplaceMode
                    )
                }
            } else {
                EmptyRecipeSlot(
                    title: slot.type.displayName,
                    date: plan.date,
                    slot: slot.type,
                    isReplaceMode: isReplaceMode
                )
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
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
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
    let id: String
    let type: MealType
    var mealEntry: MealEntry?
    
    var isFilled: Bool { mealEntry?.meal != nil }
    
    var isEaten: Bool { mealEntry?.isEaten ?? false}

    var isPro: Bool { mealEntry?.meal.recipe.isProSubscription ?? false}
        
    init(id: String, type: MealType, mealEntry: MealEntry? = nil) {
        self.id = id
        self.type = type
        self.mealEntry = mealEntry
    }
    
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
    
    // MARK: - Equatable Conformance
    static func == (lhs: MealSlot, rhs: MealSlot) -> Bool {
        return lhs.id == rhs.id // Compare only IDs
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Use ID for hashing
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

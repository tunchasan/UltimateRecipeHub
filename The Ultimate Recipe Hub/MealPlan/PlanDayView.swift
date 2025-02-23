//
//  PlanDayView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct PlanDayView: View {
    
    var plan: DailyMeals
    var mealSlots: [MealSlot]
    var onGenerateWithAICoach: () -> Void
    var cornerRadius: CGFloat = 12
    var isReplaceMode: Bool = false
    var isGenerateMealButtonVisible: Bool = true

    @State var isExpanded: Bool = false
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    @ObservedObject private var loadingVisibilityManager = LoadingVisibilityManager.shared

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
                
                let isDatePast = DateStatus.determine(for: plan.date) == .past
                if !isDatePast && !isReplaceMode && isExpanded {
                    headerButtons
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(DateStatus.determine(for: plan.date) == .past ? .gray.opacity(0.2) : .green.opacity(0.15))
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
            if !allSlotsFilled && !plan.isEmpty() {
                IconButton(
                    systemImageName: "sparkle",
                    systemImageColor: .purple,
                    action: {
                        handleMealGeneration()
                    }
                )
            }
            
            /*IconButton(
             systemImageName: "cart.fill",
             systemImageColor: .green,
             action: {}
             )*/
            
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
            
            VStack(spacing: 10) {
                
                if plan.isEmpty() && !loadingVisibilityManager.isVisible && isGenerateMealButtonVisible && !isReplaceMode {
                    RoundedButton(
                        title: "Plan day with AI Coach",
                        backgroundColor: .purple
                    ) {
                        handleMealGeneration()
                    }
                    .shadow(color: .black.opacity(0.5), radius: 2)
                }

                if !isReplaceMode && !plan.isEmpty() {
                    NutritionalInfoView(
                        onClickLockedMacro: {
                            PaywallVisibilityManager.show(triggeredBy: .attemptDisplayDayPlanMacros)
                        },
                        macros: plan.macros,
                        calories: plan.calories
                    )
                }
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
            .padding(.top, -5)
            .padding(.bottom, 10)
            
            let hydrationManager = HydrationMessageManager.shared
            let dateStatus = DateStatus.determine(for: plan.date)
            let sliderAICoachText = dateStatus == .today ? hydrationManager.getNextGoalSuggestionMessages() : ""
            let motivationalAICoachText = dateStatus == .today ? hydrationManager.getNextHydrationMessage() : "TODO: Progress"
            let goalAchievementAICoachText = dateStatus == .today ? hydrationManager.getNextWaterGoalAchievementMessages() : ""

            if !isReplaceMode && dateStatus != .future {
                WaterChallengeView(
                    challenge: plan.waterChallenge,
                    date: plan.date,
                    dateStatus: dateStatus,
                    sliderAICoachText: sliderAICoachText,
                    goalAchievementAICoachText: goalAchievementAICoachText,
                    motivationalAICoachText: motivationalAICoachText
                )
                .padding(.bottom, 20)
            }
        }
    }
    
    private func handleMealGeneration() {
        
        let user = User.shared
        
        if user.subscription == .pro {
            onGenerateWithAICoach()
        }
        
        else if user.subscription == .free {
            
            let dateStatus = DateStatus.determine(for: plan.date)
            
            if dateStatus == .today && !user.isFTPlanGenerationCompleted {
                onGenerateWithAICoach()
            }
            
            else {
                PaywallVisibilityManager.show(
                    triggeredBy: dateStatus == .today ?
                        .attemptGenerateTodayPlanOnceAgain :
                            .attemptGenerateNextDayPlan
                )                
            }
        }
    }
    
    private func createSlotView(for slot: MealSlot) -> some View {
        ZStack {
            if slot.isFilled {
                if let recipe = slot.mealEntry?.meal {
                    RecipePlanCard(
                        date: plan.date,
                        
                        model: recipe,
                        slot: slot.type,
                        
                        isActionable: DateStatus.determine(for: plan.date) != .past,
                        isReplaceMode: isReplaceMode,
                        
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

enum DateStatus {
    case past
    case today
    case future
    
    /// Determines if a given date is in the past, today, or the future.
    /// - Parameter date: The date to evaluate.
    /// - Returns: A `DateStatus` case indicating the result.
    static func determine(for date: Date) -> DateStatus {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Start of today's date
        let targetDate = calendar.startOfDay(for: date) // Start of the given date
        
        if targetDate < today {
            return .past
        } else if targetDate == today {
            return .today
        } else {
            return .future
        }
    }
}

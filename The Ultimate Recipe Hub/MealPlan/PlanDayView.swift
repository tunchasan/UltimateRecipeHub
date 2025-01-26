//
//  PlanDayView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct PlanDayView: View {
    var day: String
    var date: String
    var isToday: Bool = false
    var isPast: Bool = false
    var mealSlots: [MealSlot]
    var cornerRadius: CGFloat = 12
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            headerSection
            
            if isExpanded {
                VStack(spacing: 5) {
                    NutritionalInfoView()
                    
                    // Use a LazyVGrid for two slots per row
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(mealSlots) { slot in
                            if slot.isFilled {
                                if let recipe = RecipeSourceManager.shared.findRecipe(byID: slot.id) {
                                    RecipePlanCard(
                                        model: recipe,
                                        slotName: slot.type.displayName,
                                        isActionable: !isPast,
                                        action: {}
                                    )
                                } else {
                                    EmptyRecipeSlot(title: slot.type.displayName) {}
                                }
                            } else {
                                EmptyRecipeSlot(title: slot.type.displayName) {}
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .scaleEffect(0.95)
                    
                    if isToday {
                        WaterChallengeView()
                            .padding(.top, 5)
                    }
                }
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
                Text(day)
                    .font(.system(size: 18).bold())
                
                Text(date)
                    .font(.system(size: 16).bold())
                    .foregroundStyle(.gray)
                
                Spacer()
                
                if !isPast {
                    HStack(spacing: 10) {
                        if !allSlotsFilled {
                            IconButton(
                                systemImageName: "calendar.badge.plus",
                                systemImageColor: .green,
                                action: {}
                            )
                        }
                        IconButton(
                            systemImageName: "cart.fill",
                            systemImageColor: .green,
                            action: {}
                        )
                        IconButton(
                            systemImageName: "trash",
                            systemImageColor: .red,
                            action: {}
                        )
                    }
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
    
    private var allSlotsFilled: Bool {
        mealSlots.allSatisfy { $0.isFilled }
    }
}

struct MealSlot: Identifiable {
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
            day: "Monday",
            date: "Jan 29",
            isToday: true,
            isPast: false,
            mealSlots: mealSlots
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

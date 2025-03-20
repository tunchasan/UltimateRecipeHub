//
//  PlanView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI
import AlertToast
import ConfettiSwiftUI

struct PlanView: View {
    var isReplaceMode: Bool = false
    @State private var isVisible = false
    @State var openReplaceView: Bool = false
    @State private var isFTLandingPlanPage = false
    @State var openFTMealPlanGenerationView: Bool = false
    @ObservedObject private var mealPlanManager = MealPlanManager.shared
    @ObservedObject private var findRecipesManager = FindRecipesManager.shared
    @ObservedObject private var tabVisibilityManager = TabVisibilityManager.shared
    @ObservedObject private var loadingVisibilityManager = LoadingVisibilityManager.shared
    @State private var triggerConfetti: Int = 0

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
                            
                            let dateStatus = DateStatus.determine(for: dailyMeal.date)
                            let mealPlanStartDay = mealPlanManager.currentWeeklyPlan?.startDate ?? Date()
                            let mealPlanStartDayStatus = DateStatus.determine(for: mealPlanStartDay)
                            
                            PlanDayView(
                                plan: dailyMeal,
                                mealSlots: generateMealSlots(from: dailyMeal),
                                onGenerateWithAICoach: {
                                    handleMealGeneration(for: dailyMeal.date)
                                },
                                isReplaceMode: isReplaceMode,
                                isGenerateMealButtonVisible: !openFTMealPlanGenerationView,
                                isExpanded:
                                    dateStatus == .today
                                    || isReplaceMode
                                    || isFTLandingPlanPage
                                    || dateStatus == mealPlanStartDayStatus
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
            .toolbar(tabVisibilityManager.isVisible ? .visible : .hidden, for: .tabBar)
            .toolbar {
                if !isReplaceMode && !loadingVisibilityManager.isVisible {
                    PlanPageMenuButton(
                        systemImageName: "ellipsis.circle",
                        onClickGenerateWeeklyPlan: {
                            handleWeeklyMealGeneration()
                        }
                    )
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
            .sheet(isPresented: $openFTMealPlanGenerationView, onDismiss: {
                User.shared.setFTLandingAsComplete()
            }) {
                FTMealPlanGenerateView(
                    onCreatePlanButton: {
                        let calendar = Calendar.current
                        let today = calendar.startOfDay(for: Date()) // Today's start of day
                        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)! // Tomorrow's start of day
                        handleMealGeneration(for: mealPlanManager.isLocalTime2PMOrLater() ? tomorrow : today)
                    },
                    onManualPlanButton: {
                        openFTMealPlanGenerationView = false
                    })
                .presentationDetents([.fraction(0.4)]) // Set height to 40%
                .interactiveDismissDisabled(true) // Prevent dismissal by swipe
                .presentationBackground(Color.white) // Ensure background is solid
                .presentationCornerRadius(25) // Apply rounded corners only to the top
            }
            .onAppear {
                isVisible = true
                
                if !isReplaceMode {
                    TabVisibilityManager.showTabBar()
                    mealPlanManager.clearUpdatesCount()
                }
                
                if !User.shared.isFTLandingCompleted {
                    isFTLandingPlanPage = true
                    openFTMealPlanGenerationView = true
                }
            }
            .onDisappear(perform: {
                isVisible = false
            })
            .opacity(openFTMealPlanGenerationView || loadingVisibilityManager.isVisible ? 0.5 : 1)
            .grayscale(openFTMealPlanGenerationView || loadingVisibilityManager.isVisible ? 0.5 : 0)
            .confettiCannon(
                trigger: $triggerConfetti,
                num: 30,
                confettiSize: 15
            )
        }
    }
    
    private func handleWeeklyMealGeneration() {
        
        if User.shared.subscription == .pro {
            withAnimation {
                LoadingVisibilityManager.showLoading()
                mealPlanManager.removeWeeklyMeals(with: false)
            }
            
            TabVisibilityManager.hideTabBar()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                TabVisibilityManager.showTabBar()
                LoadingVisibilityManager.hideLoading()
                triggerConfetti += 1
                ToastVisibilityManager.show(for: "Meal plan is ready!")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    MealPlanManager.shared.generateWeeklyMeals()
                }
            }
        }
        
        else {
            PaywallVisibilityManager.show(triggeredBy: .attemptGenerateWeeklyPlan)
        }
    }
    
    private func handleMealGeneration(for date: Date) {
        withAnimation {
            LoadingVisibilityManager.showLoading()
            mealPlanManager.removeDailyMeals(for: date, with: false)
        }
        
        TabVisibilityManager.hideTabBar()
        openFTMealPlanGenerationView = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            ToastVisibilityManager.show(for: "Meal plan is ready!")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            LoadingVisibilityManager.hideLoading()
            TabVisibilityManager.showTabBar()
            triggerConfetti += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                mealPlanManager.generateMealsForSpecificDay(for: date)
                User.shared.setFTPlanGenerationComplete()
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
    var onClickGenerateWeeklyPlan: () -> Void
    var systemImageColor: Color = .green
    @ObservedObject private var mealPlanManager = MealPlanManager.shared

    @State private var showAlert: Bool = false
    @State private var alertState: AlertState = .none

    enum AlertState {
        case none
        case override
        case remove
        case create
    }
    
    var body: some View {
        Menu {
            /*Button {
             print("Add to Groceries tapped")
             } label: {
             Label("Add to Groceries", systemImage: "cart.fill")
             }*/
            
            Button {
                print("Generate Plan for Week tapped")
                let weeklyMealPlan = mealPlanManager.currentWeeklyPlan
                alertState = mealPlanManager.isWeeklyMealsEmpty(weeklyMealPlan) ? .create : .override
                showAlert = true
            } label: {
                Label("Generate Plan for Week", systemImage: "calendar")
            }
            
            let weeklyMealPlan = mealPlanManager.currentWeeklyPlan
            if !mealPlanManager.isWeeklyMealsEmpty(weeklyMealPlan) {
                Button(role: .destructive) {
                    print("Clear Current Week tapped")
                    alertState = .remove
                    showAlert = true
                } label: {
                    Label("Clear Current Week", systemImage: "trash")
                }
            }
            
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor.opacity(0.8))
                .font(.system(size: 18))
        }
        .alert(isPresented: $showAlert) {
            
            let message = alertState == .remove ?
            "Meal plan for the entire week will be deleted!" :
            alertState == .override ? "Meal plan for the entire week will be regenerated!" :
            "Meal plan for the entire week will be generated!"
            
            let buttonText = alertState == .override ?
            "Regenerate" : alertState == .create ? "Generate" : "Delete"
            
            return Alert(
                title: Text(alertState == .create ? "AI Coach" : "Are you sure?"),
                message: Text(message),
                primaryButton: .default(
                    Text("Cancel"),
                    action: {
                        alertState = .none
                    }
                ),
                secondaryButton: .destructive(
                    Text(buttonText),
                    action: {
                        if alertState == .override || alertState == .create {
                            onClickGenerateWeeklyPlan()
                        }
                        
                        if alertState == .remove {
                            withAnimation {
                                MealPlanManager.shared.removeWeeklyMeals()
                            }
                            
                            ToastVisibilityManager.show(for: "Meal plan is deleted!")
                        }
                    }
                )
            )
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}

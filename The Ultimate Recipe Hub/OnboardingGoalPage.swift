//
//  OnboardingGoalPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingGoalPage: View {
    
    @StateObject private var user = User.shared
    
    var action: () -> Void
    
    @State var isNonOfAboveButtonSelected: Bool = false
    @State var isNonConditionButtonSelectable: Bool = true
    @State var isLoseWeightSelected: Bool = false
    @State var isGainWeightSelected: Bool = false
    @State var isMaintainWeightSelected: Bool = false
    @State var selectedButtonCount: Int = 0
    
    var body: some View {
        
        VStack(alignment: .leading) {

            TypingEffectView(
                fullText: "What goals whould you like to start with?",
                fontSize: 27,
                fontColor: .black,
                fontWeight: .bold,
                aiCoachVisibility: false
            )
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 16) {

                    MultipleSelectionRichButton(
                        title: "Lose weight",
                        subTitle: "Reach your fitness goals.",
                        emoji: "🏃‍♂️",
                        isSelectable: Binding(
                            get: { !(isGainWeightSelected || isMaintainWeightSelected || isNonOfAboveButtonSelected) }, // Invert the condition
                            set: { _ in } // Optional: Leave blank if no action needed
                        )                ) {
                            isChecked in
                            isLoseWeightSelected = isChecked
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleGoal(Goal.loseWeight)
                        }
                    
                    MultipleSelectionRichButton(
                        title: "Maintain weight",
                        subTitle: "Keep a healthy balance.",
                        emoji: "🧘‍♀️",
                        isSelectable: Binding(
                            get: { !(isGainWeightSelected || isLoseWeightSelected || isNonOfAboveButtonSelected) }, // Invert the condition
                            set: { _ in } // Optional: Leave blank if no action needed
                        )
                    ) { isChecked in
                        isMaintainWeightSelected = isChecked
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleGoal(Goal.maintainWeight)
                    }
                    
                    MultipleSelectionRichButton(
                        title: "Gain weight",
                        subTitle: "Build muscle with power foods.",
                        emoji: "💪",
                        isSelectable: Binding(
                            get: { !(isLoseWeightSelected || isMaintainWeightSelected || isNonOfAboveButtonSelected) }, // Invert the condition
                            set: { _ in } // Optional: Leave blank if no action needed
                        )
                    ) { isChecked in
                        isGainWeightSelected = isChecked
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleGoal(Goal.gainWeight)
                    }
                    
                    MultipleSelectionRichButton(
                        title: "Eat healthy",
                        subTitle: "Nourish your body daily.",
                        emoji: "🍎",
                        isSelectable: $isNonConditionButtonSelectable
                    ) { isChecked in
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleGoal(Goal.eatHealthy)
                    }
                    
                    MultipleSelectionRichButton(
                        title: "Save money",
                        subTitle: "Smart meal planning saves.",
                        emoji: "💸",
                        isSelectable: $isNonConditionButtonSelectable
                    ) { isChecked in
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleGoal(Goal.saveMoney)
                    }
                    
                    MultipleSelectionRichButton(
                        title: "Plan weekly meals",
                        subTitle: "Stay organized, eat better.",
                        emoji: "📅",
                        isSelectable: $isNonConditionButtonSelectable
                    ) { isChecked in
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleGoal(Goal.planWeeklyMeals)
                    }
                    
                    MultipleSelectionRichButton(
                        title: "Build healthier habits",
                        subTitle: "Create routines for success.",
                        emoji: "🏋️‍♀️",
                        isSelectable: $isNonConditionButtonSelectable
                    ) { isChecked in
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleGoal(Goal.buildHealthierHabits)
                    }
                }
                .padding()
                .padding(.horizontal, 10)
            }
            .onAppear() {
                user.resetPreferences()
                
                print("----------Goals----------")
                user.logUserSelections()
            }
            
            Spacer()
            
            Text("We use this information to calculate and provide you with daily personalized recommendations.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            RoundedButton(
                title: selectedButtonCount > 0 ? "Continue" : "Skip"
            ) {
                action()
            }
            .animation(.easeInOut, value: selectedButtonCount > 0)
        }
        .padding(.top)
        .toolbar {
            SegmentedProgressBar(currentStep: 1)
                .frame(width: 300)
                .padding(.trailing, 35)
        }
    }
}

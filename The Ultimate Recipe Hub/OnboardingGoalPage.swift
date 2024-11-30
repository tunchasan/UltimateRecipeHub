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
        
        MultiTitledHeader(title: "Goals",
                          subTitle: "What goals whould you like to start with?")
        
        ScrollView {
            VStack(spacing: 15) {
                
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
                        print("Lose weight button tapped, isChecked: \(isChecked)")
                        
                        if isChecked {
                            user.toggleGoal(Goal.loseWeight)
                        }
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
                    print("Maintain weight button tapped, isChecked: \(isChecked)")
                    
                    if isChecked {
                        user.toggleGoal(Goal.maintainWeight)
                    }
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
                    print("Gain weight button tapped, isChecked: \(isChecked)")
                    
                    if isChecked {
                        user.toggleGoal(Goal.gainWeight)
                    }
                }
                
                MultipleSelectionRichButton(
                    title: "Eat healthy",
                    subTitle: "Nourish your body daily.",
                    emoji: "🍎",
                    isSelectable: $isNonConditionButtonSelectable
                ) { isChecked in
                    print("Eat healthy button tapped, isChecked: \(isChecked)")
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    
                    if isChecked {
                        user.toggleGoal(Goal.eatHealthy)
                    }
                }
                
                MultipleSelectionRichButton(
                    title: "Save money",
                    subTitle: "Smart meal planning saves.",
                    emoji: "💸",
                    isSelectable: $isNonConditionButtonSelectable
                ) { isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Save money button tapped, isChecked: \(isChecked)")
                    
                    if isChecked {
                        user.toggleGoal(Goal.saveMoney)
                    }
                }
                
                MultipleSelectionRichButton(
                    title: "Plan weekly meals",
                    subTitle: "Stay organized, eat better.",
                    emoji: "📅",
                    isSelectable: $isNonConditionButtonSelectable
                ) { isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Plan weekly meals button tapped, isChecked: \(isChecked)")
                    
                    if isChecked {
                        user.toggleGoal(Goal.planWeeklyMeals)
                    }
                }
                
                MultipleSelectionRichButton(
                    title: "Build healthier habits",
                    subTitle: "Create routines for success.",
                    emoji: "🏋️‍♀️",
                    isSelectable: $isNonConditionButtonSelectable
                ) { isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Build healthier habits button tapped, isChecked: \(isChecked)")
                    
                    if isChecked {
                        user.toggleGoal(Goal.buildHealthierHabits)
                    }
                }
                MultipleSelectionRichButton(
                    title: "None of the above",
                    subTitle: "Skip all other options.",
                    emoji: "🚫",
                    isSelectable: Binding(
                        get: { selectedButtonCount == 0 || isNonOfAboveButtonSelected}, // Invert the condition
                        set: { _ in } // Optional: Leave blank if no action needed
                    )                ) { isChecked in
                        print("Build healthier habits button tapped, isChecked: \(isChecked)")
                        isNonOfAboveButtonSelected = isChecked
                        isNonConditionButtonSelectable = !isChecked
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        
                        if isChecked {
                            user.toggleGoal(Goal.none)
                        }
                    }
            }
            .padding() // Optional: Adds padding to the entire VStack content
        }
        
        Spacer()
        
        Text("We use this information to calculate and provide you with daily personalized recommendations.")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
        
        Spacer()
        
        RoundedButton(title: "Continue") {
            if selectedButtonCount > 0 {
                action()
            }
        }
        .opacity(selectedButtonCount > 0 ? 1 : 0.5)
        .animation(.easeInOut, value: selectedButtonCount > 0)
    }
}

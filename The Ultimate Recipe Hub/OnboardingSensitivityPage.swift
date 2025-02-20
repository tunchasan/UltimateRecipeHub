//
//  OnboardingSensitivityPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingSensitivityPage: View {
    
    @StateObject private var user = User.shared
    
    var action: () -> Void
    
    @State var selectedButtonCount: Int = 0
    
    @State private var isForceSelected: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            TypingEffectView(
                fullText: "Are there any foods you would prefer to avoid?",
                fontSize: 27,
                fontColor: .black,
                fontWeight: .bold,
                aiCoachVisibility: false
            )
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Chicken",
                        emoji: "🍗",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidChicken) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )
                    ) {
                        isChecked in
                        selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                        user.toggleFoodSensitivity(.avoidChicken)
                    }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Meat",
                        emoji: "🥩",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidMeat) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidMeat)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Seafood",
                        emoji: "🐟",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidSeafood) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidSeafood)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Nuts",
                        emoji: "🥜",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidNuts) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidNuts)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Pork",
                        emoji: "🐖",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidPork) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidPork)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Dairy",
                        emoji: "🥛",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidDairy) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidDairy)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Grains",
                        emoji: "🌾",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidGrains) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidGrains)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Egg",
                        emoji: "🥚",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidEgg) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidEgg)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Spice",
                        emoji: "🌶️",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidSpice) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidSpice)
                        }
                    
                    MultipleSelectionRichButtonRed(
                        title: "Avoid Fruit",
                        emoji: "🍎",
                        forceSelection: Binding<Bool>(
                            get: { user.getAvoidanceList().contains(.avoidFruit) }, // Check if sensitivity is in the set
                            set: { _ in }
                        )                ) {
                            isChecked in
                            selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                            user.toggleFoodSensitivity(.avoidFruit)
                        }
                }
                .padding()
            }
            .onAppear() {
                print("----------Food Sensitivities----------")
                user.logUserSelections()
            }
            
            Spacer()
            
            Text("We use this information to calculate and provide you with daily personalized recommendations.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            RoundedButton(title: user.foodSensitivities.count > 0 ? "Continue" : "Skip"
            ) {
                action()
            }
            .animation(.easeInOut, value: user.foodSensitivities.count > 0)
        }
        .padding(.top)
        .toolbar {
            SegmentedProgressBar(currentStep: 4)
                .frame(width: 300)
                .padding(.trailing, 35)
        }
    }
}

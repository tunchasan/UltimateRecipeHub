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
    @State private var isReachedTheSelectionLimit: Bool = false

    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Are there any foods you would prefer to avoid?")
                .padding(.leading)
                .padding(.horizontal)
                .font(.system(size: 27).bold())
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 15) {
                
                let systemName = isReachedTheSelectionLimit ? "exclamationmark.bubble.fill" : "info.circle.fill"
                let message = isReachedTheSelectionLimit ?
                  "Limit reached! Deselect to change."
                : "Choose up to \(user.getAvoidanceLimit()) items"
                
                Image(systemName: systemName)
                    .font(.system(size: 27).bold())
                    .foregroundColor(.orange)
                
                Text(message)
                    .font(.system(size: 16))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .scaleEffect(isReachedTheSelectionLimit ? 1.05 : 1)
            
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
                        validateSelectionLinit()
                    }
                    .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidChicken))

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
                            validateSelectionLinit()
                        }
                        .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidMeat))

                    if user.foodPreference != .pescatarian {
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
                                validateSelectionLinit()
                            }
                            .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidSeafood))

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
                            validateSelectionLinit()
                        }
                        .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidNuts))

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
                            validateSelectionLinit()
                        }
                        .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidPork))

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
                            validateSelectionLinit()
                        }
                        .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidDairy))

                    if !(user.foodPreference == .vegan || user.foodPreference == .vegetarian) {
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
                                validateSelectionLinit()
                            }
                            .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidGrains))

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
                            validateSelectionLinit()
                        }
                        .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidEgg))

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
                            validateSelectionLinit()
                        }
                        .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidSpice))

                    if !(user.foodPreference == .vegan || user.foodPreference == .vegetarian) {
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
                                validateSelectionLinit()
                            }
                            .disabled(isReachedTheSelectionLimit && !user.foodSensitivities.contains(.avoidFruit))

                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
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
    
    private func validateSelectionLinit() {
        withAnimation {
            isReachedTheSelectionLimit = selectedButtonCount >= user.getAvoidanceLimit()
        }
    }
}

#Preview{
    OnboardingSensitivityPage(action: {
        
    })
}

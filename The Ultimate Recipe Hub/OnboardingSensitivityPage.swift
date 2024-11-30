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
        
        MultiTitledHeader(title: "Food Sensitivities",
                          subTitle: "Choose the foods you'd like to avoid.")
        
        ScrollView {
            VStack(spacing: 15) {
                
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
            .padding() // Adds padding to the entire VStack content
        }
        .onAppear(){
            print("----------Food Sensitivities----------")
            user.logUserSelections()
        }
        
        Spacer()
        
        RoundedButton(title: "Continue") {
            if user.foodSensitivities.count > 0 {
                action()
            }
        }
        .padding(.top, 3)
        .opacity(user.foodSensitivities.count > 0 ? 1 : 0.5)
        .animation(.easeInOut, value: user.foodSensitivities.count > 0)
    }
}

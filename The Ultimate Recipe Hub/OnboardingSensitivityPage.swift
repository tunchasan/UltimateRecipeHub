//
//  OnboardingSensitivityPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingSensitivityPage: View {
    
    var action: () -> Void

    @State var selectedButtonCount: Int = 0

    var body: some View {
        
        MultiTitledHeader(title: "Food Sensitivities",
                          subTitle: "Choose the foods you'd like to avoid.")
        
        ScrollView {
            VStack(spacing: 15) {
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Chicken",
                    emoji: "🍗"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Chicken button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Meat",
                    emoji: "🥩"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Meat button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Seafood",
                    emoji: "🐟"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Seafood button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Nuts",
                    emoji: "🥜"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Nuts button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Pork",
                    emoji: "🐖"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Pork button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Dairy",
                    emoji: "🥛"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Dairy button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Grains",
                    emoji: "🌾"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Grains button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Egg",
                    emoji: "🥚"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Egg button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Spice",
                    emoji: "🌶️"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Spice button tapped")
                }
                
                MultipleSelectionRichButtonRed(
                    title: "Avoid Fruit",
                    emoji: "🍎"
                ) {
                    isChecked in
                    selectedButtonCount = isChecked ? selectedButtonCount + 1 : selectedButtonCount - 1
                    print("Avoid Fruit button tapped")
                }
            }
            .padding() // Adds padding to the entire VStack content
        }
        
        Spacer()
        
        RoundedButton(title: "Continue") {
            if selectedButtonCount > 0 {
                action()
            }
        }
        .padding(.top, 3)
        .opacity(selectedButtonCount > 0 ? 1 : 0.5)
        .animation(.easeInOut, value: selectedButtonCount > 0)
    }
}

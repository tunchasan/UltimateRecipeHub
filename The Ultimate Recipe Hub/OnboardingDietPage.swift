//
//  OnboardingDietPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingDietPage: View {
    
    @StateObject private var user = User.shared

    @State var isButtonSelectable: Bool = true
    @State var shouldDisplayNextButton: Bool = false

    var action: () -> Void
    
    var body: some View {
        
        MultiTitledHeader(title: "Food Preferences",
                          subTitle: "We'll adapt our recommendations to your preferences.")
        
        ScrollView {
            VStack(spacing: 20) {
                
                SingleSelectionRichButton(
                    title: "Flexible",
                    subTitle: "Enjoy a variety of meals.",
                    emoji: "🍽️",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    isButtonSelectable = !isChecked
                    shouldDisplayNextButton = false
                    print("Flexible button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.flexible)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Vegetarian",
                    subTitle: "Focus on plant-based meals.",
                    emoji: "🥗",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    isButtonSelectable = !isChecked
                    shouldDisplayNextButton = false
                    print("Vegetarian button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.vegetarian)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Vegan",
                    subTitle: "Stick to 100% plant-based diet.",
                    emoji: "🌱",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    isButtonSelectable = !isChecked
                    shouldDisplayNextButton = false
                    print("Vegan button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.vegan)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Halal",
                    subTitle: "Adhere to halal dietary laws.",
                    emoji: "🕌",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    isButtonSelectable = !isChecked
                    shouldDisplayNextButton = false
                    print("Halal button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.halal)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Gluten Free",
                    subTitle: "Avoid gluten for better digestion.",
                    emoji: "🌾",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    isButtonSelectable = !isChecked
                    shouldDisplayNextButton = false
                    print("Gluten Free button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.glutenFree)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Pescatarian",
                    subTitle: "Focus on seafood and veggies.",
                    emoji: "🐟",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    shouldDisplayNextButton = false
                    isButtonSelectable = !isChecked
                    print("Pescatarian button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.pescatarian)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Low Keto",
                    subTitle: "Low-carb, high-fat meals.",
                    emoji: "🥓",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    shouldDisplayNextButton = false
                    isButtonSelectable = !isChecked
                    print("Low Keto button tapped")
                    
                    if(isChecked){
                        user.selectFoodPreference(FoodPreference.lowKeto)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
            }
            .padding() // Optional: Adds padding to the entire VStack content
        }
        .onAppear(){

            if !isButtonSelectable {
                shouldDisplayNextButton = true
            }
        }
        
        RoundedButton(title: "Continue") {
            action()
        }
        .padding(.bottom, 10)
        .opacity(shouldDisplayNextButton ? 1 : 0)
        .animation(.easeInOut, value: shouldDisplayNextButton)
    }
}

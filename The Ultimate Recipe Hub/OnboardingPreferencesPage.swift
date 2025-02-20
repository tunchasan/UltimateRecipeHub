//
//  OnboardingDietPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingPreferencesPage: View {
    
    @StateObject private var user = User.shared
    
    @State var isButtonSelectable: Bool = true
    @State var shouldDisplayNextButton: Bool = false
    
    var action: () -> Void
    
    var body: some View {
        
        VStack(alignment: .leading) {
            TypingEffectView(
                fullText: "Are you following a specific diet?",
                fontSize: 27,
                fontColor: .black,
                fontWeight: .bold,
                aiCoachVisibility: false
            )
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 16) {

                    SingleSelectionRichButton(
                        title: "Flexible",
                        subTitle: "Enjoy a variety of meals.",
                        emoji: "🍽️",
                        isSelectable: $isButtonSelectable
                    ) {
                        isChecked in
                        isButtonSelectable = !isChecked
                        shouldDisplayNextButton = false
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.flexible)
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
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.glutenFree)
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
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.pescatarian)
                        }
                    }
                    
                    SingleSelectionRichButton(
                        title: "Low Carb",
                        subTitle: "Low-carb, high-fat meals.",
                        emoji: "🥓",
                        isSelectable: $isButtonSelectable
                    ) {
                        isChecked in
                        shouldDisplayNextButton = false
                        isButtonSelectable = !isChecked
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.lowKeto)
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
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.halal)
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
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.vegetarian)
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
                        
                        if(isChecked){
                            shouldDisplayNextButton = true
                            user.selectFoodPreference(FoodPreference.vegan)
                        }
                    }
                }
                .padding()
            }
            .onAppear(){
                
                user.resetCookingSkill()
                
                print("----------Food Preferences----------")
                user.logUserSelections()
                
                if !isButtonSelectable {
                    shouldDisplayNextButton = true
                }
            }
            
            Spacer()
            
            Text("We use this information to calculate and provide you with daily personalized recommendations.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            RoundedButton(
                title: "Continue",
                backgroundColor: shouldDisplayNextButton ? .green : .gray
            ) {
                action()
            }
            .disabled(!shouldDisplayNextButton)
            .opacity(shouldDisplayNextButton ? 1 : 0.75)
            .animation(.easeInOut, value: shouldDisplayNextButton)
        }
        .padding(.top)
        .toolbar {
            SegmentedProgressBar(currentStep: 2)
                .frame(width: 300)
                .padding(.trailing, 35)
        }
    }
}

#Preview {
    OnboardingPreferencesPage {
        
    }
}

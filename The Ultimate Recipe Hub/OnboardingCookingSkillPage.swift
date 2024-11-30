//
//  OnboardingCookingSkillPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingCookingSkillPage: View {
    
    var action: () -> Void
    
    @StateObject private var user = User.shared

    @State var isButtonSelectable: Bool = true
    @State var shouldDisplayNextButton: Bool = false

    var body: some View {
        
        MultiTitledHeader(title: "Cooking Skills",
                          subTitle: "Choose your cooking expertise.")
        
        ScrollView {
            VStack(spacing: 20) {
                
                SingleSelectionRichButton(
                    title: "Beginner",
                    subTitle: "Start with basics.",
                    emoji: "🍳",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    shouldDisplayNextButton = false
                    isButtonSelectable = !isChecked
                    
                    if(isChecked){
                        user.selectCookingSkill(CookingSkill.beginner)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Intermediate",
                    subTitle: "Sharpen your cooking skills.",
                    emoji: "🥘",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    shouldDisplayNextButton = false
                    isButtonSelectable = !isChecked
                   
                    if(isChecked){
                        user.selectCookingSkill(CookingSkill.intermediate)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
                SingleSelectionRichButton(
                    title: "Advanced",
                    subTitle: "Master advanced techniques.",
                    emoji: "👨‍🍳",
                    isSelectable: $isButtonSelectable
                ) {
                    isChecked in
                    shouldDisplayNextButton = false
                    isButtonSelectable = !isChecked
                    
                    if(isChecked){
                        user.selectCookingSkill(CookingSkill.advanced)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Adjust delay as per animation duration
                            action()
                        }
                    }
                }
                
            }
            .padding() // Optional: Adds padding to the entire VStack content
        }
        .onAppear(){

            user.validateFoodSensitivities()
            
            print("----------Cooking Skills----------")
            user.logUserSelections()

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

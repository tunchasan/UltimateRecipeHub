//
//  OnboardingCookingSkillPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct OnboardingCookingSkillPage: View {
    
    var action: () -> Void
    
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
                    print("Beginner button tapped")
                    
                    if(isChecked){
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
                    print("Intermediate button tapped")
                   
                    if(isChecked){
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
                    print("Advanced button tapped")
                    
                    if(isChecked){
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

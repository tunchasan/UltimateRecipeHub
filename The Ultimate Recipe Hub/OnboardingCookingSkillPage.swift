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
        
        VStack(alignment: .leading) {
            
            Text("How would you describe your cooking skill?")
                .padding(.leading)
                .padding(.horizontal)
                .font(.system(size: 27).bold())
                .multilineTextAlignment(.leading)

            ScrollView {
                VStack(spacing: 16) {

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
                            shouldDisplayNextButton = true
                            user.selectCookingSkill(CookingSkill.beginner)
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
                            shouldDisplayNextButton = true
                            user.selectCookingSkill(CookingSkill.intermediate)
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
                            shouldDisplayNextButton = true
                            user.selectCookingSkill(CookingSkill.advanced)
                        }
                    }
                }
                .padding()
            }
            .onAppear(){
                
                user.validateFoodSensitivities()
                
                print("----------Cooking Skills----------")
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
            SegmentedProgressBar(currentStep: 3)
                .frame(width: 300)
                .padding(.trailing, 35)
        }
    }
}

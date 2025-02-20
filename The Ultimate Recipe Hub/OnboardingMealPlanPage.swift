//
//  OnboardingCookingSkillPage 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 20.02.2025.
//

import SwiftUI

struct OnboardingMealPlanPage: View {
    
    var action: () -> Void
            
    var body: some View {
        
        Spacer()

        VStack(spacing: 60) {
            VStack(spacing: 60) {
                
                Text("Personalized\nmeal planning")
                    .font(.system(size: 32).bold())
                    .multilineTextAlignment(.leading)
                
                Image("Onboarding Meal Plan")
                
                Text("Plan your week’s meals in\nminutes—or let our AI craft a\npersonalized meal plan just for you!")
                    .font(.system(size: 18))
                    .lineSpacing(2)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 20) {
                RoundedButton(
                    title: "Next",
                    maxWidth: 150
                ) {
                    action()
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.green.opacity(0.8))
                            .frame(width: 10, height: 10)
                        
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 10, height: 10)
                        
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        
        Spacer()
    }
}

#Preview {
    OnboardingMealPlanPage(action: {})
}

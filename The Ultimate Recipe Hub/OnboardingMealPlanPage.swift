//
//  OnboardingCookingSkillPage 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 20.02.2025.
//

import SwiftUI

struct OnboardingMealPlanPage: View {
    
    var action: () -> Void
    @State private var isAnimating = false // Controls animation
    
    var body: some View {
        
        Spacer()

        VStack(spacing: 60) {
            VStack(spacing: 70) {
                
                Text("Personalized\nmeal planning")
                    .font(.system(size: 32).bold())
                    .multilineTextAlignment(.leading)
                
                Image("Onboarding Meal Plan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .scaleEffect(isAnimating ? 1.05 : 1) // Scale animation
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true // Start animation when view appears
                    }
                
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

//
//  OnboardingMealPlanPage 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 20.02.2025.
//

import SwiftUI

struct OnboardingHealtyMealPage: View {
    
    var action: () -> Void
    @State private var mealCount: Int = 0
    @State private var isAnimating = false // Controls animation

    var body: some View {
        Spacer()

        VStack(spacing: 80) {
            VStack(spacing: 60) {
                
                Text(formattedText())
                    .multilineTextAlignment(.leading)
                    .onAppear {
                        animateMealCount()
                    }
                
                Image("Onboarding Healthy Meals")
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
                
                Text("There's a delicious meal for\neveryone, for every diet.")
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
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 10, height: 10)
                        
                        Circle()
                            .fill(Color.green.opacity(0.8))
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
    
    private func animateMealCount() {
        mealCount = 0
        let duration = 2.0 // Animation duration in seconds
        let totalSteps = 50 // Number of updates
        
        let stepValue = 500 / totalSteps
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: duration / Double(totalSteps), repeats: true) { timer in
            if currentStep >= totalSteps {
                mealCount = 500
                timer.invalidate()
            } else {
                withAnimation(.easeOut(duration: 0.05)) {
                    mealCount += stepValue
                }
                currentStep += 1
            }
        }
    }
    
    private func formattedText() -> AttributedString {
        
        var numberText = AttributedString("\(mealCount)+ ")
        numberText.foregroundColor = .green
        numberText.font = .system(size: 36).bold()
        
        var remainedText = AttributedString("delicious,\nhealthy meals")
        remainedText.foregroundColor = .black
        remainedText.font = .system(size: 32).bold()
        
        return numberText + remainedText
    }
}

#Preview {
    OnboardingHealtyMealPage(action: {})
}

//
//  LoadingViewExample.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 21.02.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var currentStep = 0 // Track current text index
    @State private var animatedText = "Adapting needs..." // Default text
    @State private var textOpacity = 1.0 // Controls fade effect
    private let loadingSteps = ["Adapting needs...", "Collecting recipes...", "Building plans...", "Optimizing nutrition..."]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text(animatedText)
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .opacity(textOpacity) // Apply fade effect
                    .animation(.easeInOut(duration: 0.5), value: textOpacity) // Animate opacity
                    .onAppear {
                        startAnimation()
                    }
                
            }
        }
    }
    
    private func startAnimation() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.5)) {
                textOpacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Wait for fade out
                currentStep = (currentStep + 1) % loadingSteps.count // Change step
                animatedText = loadingSteps[currentStep] // Set new text

                // Fade in after changing text
                withAnimation(.easeInOut(duration: 0.5)) {
                    textOpacity = 1
                }
            }
        }
    }
}

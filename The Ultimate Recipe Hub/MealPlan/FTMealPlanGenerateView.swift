//
//  FTMealPlanGenerateView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 21.02.2025.
//

import SwiftUI

struct FTMealPlanGenerateView: View {
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("Welcome to\nRecipe Hub: Meal Planner")
                    .multilineTextAlignment(.center)
                    .font(.title).bold()
                    .lineSpacing(5)
                    .padding()
                
                Divider()
                    .frame(height: 1) // Adjust thickness
                    .background(Color.gray.opacity(0.3)) // Light gray color
                    .padding(.horizontal, 8) // Add padding to align with text
                
                Text("Choose your week’s meals in minutes, or let our\nAI create a personalized meal plan for you.")
                    .foregroundStyle(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Spacer()
            
            VStack(spacing: 0) {
                RoundedButton(
                    title: "Create a meal plan",
                    maxWidth: 300,
                    backgroundColor: .purple,
                    action: {
                        
                    })
                
                TextButton(
                    title: "Do it manually",
                    titleColor: .purple,
                    titleFontSize: 16,
                    action: {
                        
                    }
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct NonDismissableSheetExample: View {
    @State private var isSheetPresented = true
    
    var body: some View {
        VStack {
            Button("Open Sheet") {
                isSheetPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isSheetPresented) {
            FTMealPlanGenerateView()
                .presentationDetents([.fraction(0.4)]) // Set height to 40%
                .interactiveDismissDisabled(true) // Prevent dismissal by swipe
                .presentationBackground(Color.white) // Ensure background is solid
                .presentationCornerRadius(25) // Apply rounded corners only to the top
        }
    }
}

struct NonDismissableSheetExample_Previews: PreviewProvider {
    static var previews: some View {
        NonDismissableSheetExample()
    }
}


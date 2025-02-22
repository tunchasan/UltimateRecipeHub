//
//  FTMealPlanGenerateView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 22.02.2025.
//

import SwiftUI

struct PaywallView: View {
    var directory: PaywallVisibilityManager.PaywallTrigger
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("Paywall")
                    .multilineTextAlignment(.center)
                    .font(.title).bold()
                    .lineSpacing(5)
                    .padding()
                
                Divider()
                    .frame(height: 1) // Adjust thickness
                    .background(Color.gray.opacity(0.3)) // Light gray color
                    .padding(.horizontal, 8) // Add padding to align with text
                
                Text("\(directory)")
                    .multilineTextAlignment(.center)
                    .font(.title3).bold()
                    .lineSpacing(5)
                    .padding()
                
                Spacer()
                
                VStack(spacing: 20) {
                    RoundedButton(
                        title: "Monthly Package") {
                            
                        }
                    
                    RoundedButton(
                        title: "Yearly Package",
                        backgroundColor: .orange) {
                            
                        }

                    RoundedButton(
                        title: "Lifetime Package",
                        backgroundColor: .purple) {
                            
                        }
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct PaywallExample: View {
    @State private var isSheetPresented = true
    
    var body: some View {
        VStack {
            Button("Open Sheet") {
                isSheetPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isSheetPresented) {
            PaywallView(directory: .attemptAddRecipeToFavoritesOver3)
            .presentationDetents([.fraction(0.4)]) // Set height to 40%
            .presentationBackground(Color.white) // Ensure background is solid
            .presentationCornerRadius(25) // Apply rounded corners only to the top
        }
    }
}

struct PaywallExample_Previews: PreviewProvider {
    static var previews: some View {
        PaywallExample()
    }
}

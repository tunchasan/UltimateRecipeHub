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
        ZStack {
            // ✅ Background Image
            Image("PaywallBackground")
                .ignoresSafeArea()
            
            IconButton(
                systemImageName: "x.circle",
                size: 40
            ) {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(25)

            VStack (spacing: 20) {
                Text("Unlock All Pro Features")
                    .font(.title.bold())
                    .foregroundColor(.black)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        featureRow("Unlimited personalized meal plans")
                        featureRow("Hundreds of exclusive recipes")
                        featureRow("Generate your grocery list for any meal")
                        featureRow("Get nutrition information")
                        featureRow("Access to water challenge")
                        
                        VStack(spacing: 20) {
                            PaywallButton(
                                title: "Monthly",
                                badgeText: "3 days free",
                                subTitle: "$1.99/month",
                                priceText: "$1.99",
                                periodText: "per month"
                            ) {
                                
                            }
                            
                            PaywallButton(
                                title: "Annual",
                                badgeText: "save 60%",
                                subTitle: "$9.99/year",
                                priceText: "$0.83",
                                periodText: "per year",
                                isSelected: true
                            ) {
                                
                            }
                            
                            PaywallButton(
                                title: "Lifetime",
                                badgeText: "best value",
                                subTitle: "One-time payment",
                                priceText: "$14.99"
                            ) {
                                
                            }
                            
                            RoundedButton(
                                title: "Continue",
                                backgroundColor: .green) {
                                    
                                }
                            
                        }
                        .padding(.top, 15)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.365) // ✅ Push content down by 40% of screen height
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // ✅ Align everything to the top
        }
    }
    
    /// Reusable HStack for Features
    func featureRow(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.green)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
    }
}


/*Image("PaywallStock")
 .resizable()
 .scaledToFit()
 .frame(width: UIScreen.main.bounds.width)
 .clipped()
 .ignoresSafeArea()
 .frame(maxHeight: .infinity, alignment: .top)*/

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
                .presentationBackground(Color.white) // Ensure background is solid
                .presentationCornerRadius(25) // Apply rounded corners only to the top
        }
    }
}

struct PaywallExample_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(directory: .attemptAddRecipeToFavoritesOver3)
    }
}

/*VStack(spacing: 0) {
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
 */

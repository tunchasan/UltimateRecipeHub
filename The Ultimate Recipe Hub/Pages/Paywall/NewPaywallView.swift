//
//  NewPaywallView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.02.2025.
//

import SwiftUI

enum PaywallSelection {
    case firstPackage
    case secondPackage
    case thirdPackage
}

struct NewPaywallView: View {
    var directory: PaywallVisibilityManager.PaywallTrigger
    @Environment(\.presentationMode) var presentationMode
    
    @State var selection: PaywallSelection = .secondPackage
    @State var continueButtonText: String = "Continue"
    @State var continueButtonSubText: String = ""

    var body: some View {
        VStack(spacing: -40) {
            ZStack {
                Image("PaywallStock")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height * 0.24
                    )
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,  // 80% of image is clear
                        Color.clear,  // 80% of image is clear
                        Color.clear,  // 80% of image is clear
                        Color.clear,  // 80% of image is clear
                        Color.white.opacity(0.8),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.24
                )
                
                IconButton(
                    systemImageName: "xmark",
                    systemImageColor: .black,
                    size: 28,
                    fontSizeMultiplier: 0.55
                ) {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.24,
                    alignment: .topTrailing
                )
                .offset(x:-10, y:10)
            }
            
            VStack (spacing: 0) {
                Text("Unlock All Pro Features")
                    .font(.system(size: 28).bold())
                    .foregroundColor(.black)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            featureRow("Unlimited personalized meal plans")
                            featureRow("Hundreds of exclusive recipes")
                            featureRow("Generate your grocery list for any meal")
                            featureRow("Get nutrition information")
                            featureRow("Access to water challenge")
                        }
                        .padding(.horizontal, 25)
                        
                        VStack(spacing: 15) {
                            PaywallButton(
                                title: "Monthly",
                                badgeText: "3 days free",
                                subTitle: "$1.99/month",
                                priceText: "$1.99",
                                periodText: "per month",
                                isSelected: selection == .firstPackage
                            ) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                                withAnimation {
                                    selection = .firstPackage
                                    continueButtonText = "Start 3-Days Free Trail"
                                    continueButtonSubText = "then \("$1.99")/month"
                                }
                            }
                            .scaleEffect(selection == .firstPackage ? 1.075 : 1)

                            PaywallButton(
                                title: "Annual",
                                badgeText: "save 60%",
                                subTitle: "$9.99/year",
                                priceText: "$0.83",
                                periodText: "per year",
                                discountText: "$23.99",
                                isSelected: selection == .secondPackage
                            ) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                                withAnimation {
                                    selection = .secondPackage
                                    continueButtonText = "Continue"
                                    continueButtonSubText = ""
                                }
                            }
                            .scaleEffect(selection == .secondPackage ? 1.075 : 1)

                            PaywallButton(
                                title: "Lifetime",
                                badgeText: "best value",
                                subTitle: "One-time payment",
                                priceText: "$14.99",
                                isSelected: selection == .thirdPackage
                            ) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                
                                withAnimation {
                                    selection = .thirdPackage
                                    continueButtonText = "Continue"
                                    continueButtonSubText = ""
                                }
                            }
                            .scaleEffect(selection == .thirdPackage ? 1.075 : 1)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.top, 20)
                
                VStack (spacing: 20) {
                    
                    VStack (spacing: -5) {
                        Button(action: {
                            
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                        }) {
                            VStack (spacing: 4){
                                Text(continueButtonText)
                                    .font(.system(size: 18).bold())
                                
                                if !continueButtonSubText.isEmpty {
                                    Text(continueButtonSubText)
                                        .font(.system(size: 14).bold())
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                        .padding(.horizontal, 15)
                        .buttonStyle(PlainButtonStyle())
                        
                        if selection == .firstPackage {
                            Text("No Payment now!")
                                .font(.system(size: 14))
                        }
                    }

                    HStack() {
                        LightTextButton(
                            title: "Restore Purchase",
                            titleFontSize: 12,
                            maxHeight: 5,
                            action: {
                                // TODO
                            }
                        )
                        
                        LightTextButton(
                            title: "Terms & Conditions",
                            titleFontSize: 12,
                            maxHeight: 5,
                            action: {
                                // TODO
                            }
                        )
                        
                        LightTextButton(
                            title: "Privacy Policy",
                            titleFontSize: 12,
                            maxHeight: 5,
                            action: {
                                // TODO
                            }
                        )
                    }
                }
            }
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

struct NewPaywallExample: View {
    @State private var isSheetPresented = true
    
    var body: some View {
        VStack {
            Button("Open Sheet") {
                isSheetPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isSheetPresented) {
            NewPaywallView(directory: .attemptAddRecipeToFavoritesOver3)
                .interactiveDismissDisabled(true)
        }
    }
}

struct NewPaywallExample_Previews: PreviewProvider {
    static var previews: some View {
        NewPaywallExample()
    }
}

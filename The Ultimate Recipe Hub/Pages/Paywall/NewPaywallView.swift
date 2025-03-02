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
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared
    
    @State var selection: PaywallSelection = .secondPackage
    @State var continueButtonText: String = "Continue"
    @State var continueButtonSubText: String = ""
    @State private var openTermsAndConditions = false
    @State private var openPrivacyAndPolicy = false
    @State private var isOperating = false
    @State private var package: SubscriptionPlan  = .monthly

    var body: some View {
        VStack(spacing: -40) {
            ZStack {
                Image("PaywallStock2")
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
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
                        
                        VStack(spacing: 12) {
                            PaywallButton(
                                title: "Monthly",
                                badgeText: "3 days free",
                                subTitle: "$1.99/month",
                                priceText: "$1.99",
                                periodText: "per month",
                                isSelected: selection == .firstPackage
                            ) {
                                if !isOperating {
                                    package = .monthly
                                    
                                    withAnimation {
                                        selection = .firstPackage
                                        continueButtonText = "Start 3-Days Free Trail"
                                        continueButtonSubText = "then \("$1.99")/month"
                                    }
                                }
                            }
                            .disabled(isOperating ? true : false)
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
                                if !isOperating {
                                    package = .yearly
                                    
                                    withAnimation {
                                        selection = .secondPackage
                                        continueButtonText = "Continue"
                                        continueButtonSubText = ""
                                    }
                                }
                            }
                            .disabled(isOperating ? true : false)
                            .scaleEffect(selection == .secondPackage ? 1.075 : 1)
                            
                            PaywallButton(
                                title: "Lifetime",
                                badgeText: "best value",
                                subTitle: "One-time payment",
                                priceText: "$14.99",
                                isSelected: selection == .thirdPackage
                            ) {
                                if !isOperating {
                                    package = .lifetime
                                    
                                    withAnimation {
                                        selection = .thirdPackage
                                        continueButtonText = "Continue"
                                        continueButtonSubText = ""
                                    }
                                }
                            }
                            .disabled(isOperating ? true : false)
                            .scaleEffect(selection == .thirdPackage ? 1.075 : 1)
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.top, 20)
                
                VStack (spacing: 20) {
                    
                    VStack (spacing: -5) {
                        Button(action: {
                            if !isOperating {
                                withAnimation { isOperating = true }
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                subscriptionManager.purchase(plan: package) { result in
                                    switch result {
                                    case .success(let hasProAccess):
                                        if hasProAccess {
                                            User.shared.subscription = .pro
                                            print("✅ Purchase successful: User has Pro access")
                                            presentationMode.wrappedValue.dismiss()
                                        } else {
                                            print("⚠️ Purchase completed: No active subscription")
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    case .failure(let error):
                                        print("❌ Purchase failed: \(error.localizedDescription)")
                                        
                                        withAnimation {
                                            isOperating = false
                                        }
                                    }
                                }
                            }
                        }) {
                            VStack (spacing: 4){
                                if isOperating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                                else {
                                    Text(continueButtonText)
                                        .font(.system(size: 18).bold())
                                    
                                    if !continueButtonSubText.isEmpty {
                                        Text(continueButtonSubText)
                                            .font(.system(size: 14).bold())
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 55)
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
                            titleColor: isOperating ? .gray : .black,
                            titleFontSize: 12,
                            maxHeight: 5,
                            action: {
                                withAnimation { isOperating = true }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                subscriptionManager.restorePurchases { result in
                                    switch result {
                                    case .success(let hasProAccess):
                                        if hasProAccess {
                                            User.shared.subscription = .pro
                                            print("✅ Restore successful: User has Pro access")
                                            presentationMode.wrappedValue.dismiss()
                                        } else {
                                            print("⚠️ Restore completed: No active subscription")
                                            withAnimation {
                                                isOperating = false
                                            }
                                        }
                                    case .failure(let error):
                                        print("❌ Restore failed: \(error.localizedDescription)")
                                        withAnimation {
                                            isOperating = false
                                        }
                                    }
                                }
                            }
                        )
                        .disabled(isOperating ? true : false)
                        
                        LightTextButton(
                            title: "Terms & Conditions",
                            titleColor: isOperating ? .gray : .black,
                            titleFontSize: 12,
                            maxHeight: 5,
                            action: {
                                openTermsAndConditions = true
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        )
                        .disabled(isOperating ? true : false)
                        
                        LightTextButton(
                            title: "Privacy Policy",
                            titleColor: isOperating ? .gray : .black,
                            titleFontSize: 12,
                            maxHeight: 5,
                            action: {
                                openPrivacyAndPolicy = true
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        )
                        .disabled(isOperating ? true : false)
                    }
                }
            }
        }
        .sheet(isPresented: $openTermsAndConditions) { // ✅ Opens Safari in a modal sheet
            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                SafariView(url: url)
            }
        }
        .sheet(isPresented: $openPrivacyAndPolicy) { // ✅ Opens Safari in a modal sheet
            if let url = URL(string: "https://tunchasan.github.io/Recipe-Hub-Meal-Planner-Pro/privacypolicy/") {
                SafariView(url: url)
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

//
//  NewPaywallView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.02.2025.
//

import SwiftUI

struct NewPaywallView: View {
    var directory: PaywallVisibilityManager.PaywallTrigger
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: -20) {
            ZStack {
                Image("PaywallStock")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height * 0.275
                    )
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,  // 80% of image is clear
                        Color.clear,  // 80% of image is clear
                        Color.clear,  // 80% of image is clear
                        Color.clear,  // 80% of image is clear
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.8),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.275
                )
                
                IconButton(
                    systemImageName: "x.circle",
                    systemImageColor: .black,
                    size: 32,
                    fontSizeMultiplier: 0.75
                ) {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.275,
                    alignment: .topTrailing
                )
                .offset(x:-10, y:10)
            }
            
            VStack (spacing: 0) {
                Text("Unlock All Pro Features")
                    .font(.title.bold())
                    .foregroundColor(.black)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            featureRow("Unlimited personalized meal plans")
                            featureRow("Hundreds of exclusive recipes")
                            featureRow("Generate your grocery list for any meal")
                            featureRow("Get nutrition information")
                            featureRow("Access to water challenge")
                        }
                        .padding(.horizontal, 25)
                        
                        VStack(spacing: 12) {
                            RoundedButton(
                                title: "Monthly Package",
                                backgroundColor: .black) {
                                    
                                }
                            
                            RoundedButton(
                                title: "Yearly Package",
                                backgroundColor: .black) {
                                    
                                }
                            
                            RoundedButton(
                                title: "Lifetime Package",
                                backgroundColor: .black) {
                                    
                                }
                            
                            
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.top, 20)
                
                Spacer()

                VStack (spacing: 25) {
                                        
                    RoundedButton(
                        title: "Continue",
                        backgroundColor: .green) {
                            
                        }
                        .padding(.horizontal, 25)

                    HStack {
                        TextButton(
                            title: "Restore Purchase",
                            titleFontSize: 12,
                            maxHeight: 10,
                            action: {
                                // TODO
                            }
                        )
                        
                        TextButton(
                            title: "Terms & Conditions",
                            titleFontSize: 12,
                            maxHeight: 10,
                            action: {
                                // TODO
                            }
                        )
                        
                        TextButton(
                            title: "Privacy Policy",
                            titleFontSize: 12,
                            maxHeight: 10,
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

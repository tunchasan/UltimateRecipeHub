//
//  FTMealPlanGenerateView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.03.2025.
//

import SwiftUI

struct RateUsView: View {
    var onAskMeLaterButton: () -> Void
    var onNotReallyButton: () -> Void
    var onLoveItButton: () -> Void
    
    var body: some View {
        VStack {
            Text("RATE US!")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.title).bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "8CC76D"))
            
            Spacer()
            
            Text("Do You Enjoy\nRecipe Hub: Meal Planner")
                .foregroundStyle(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .font(.system(size: 18).bold())
                .lineSpacing(4)
            
            Spacer()
                        
            VStack(spacing: 20) {
                
                HStack(spacing: -10) {
                    
                    RoundedButton(
                        title: "Not Really",
                        maxWidth: 300,
                        backgroundColor: .red,
                        action: {
                            print("Not Really")
                            onNotReallyButton()
                        })
                    .shadow(color: .black.opacity(0.8), radius: 1)
                    
                    RoundedButton(
                        title: "Love it!",
                        maxWidth: 300,
                        backgroundColor: .purple,
                        action: {
                            print("Love it!")
                            onLoveItButton()
                        })
                    .shadow(color: .black.opacity(0.8), radius: 1)
                }
                
                TextButton(
                    title: "Ask me later",
                    titleColor: .black,
                    titleFontSize: 16,
                    maxHeight: 10,
                    isUnderLined: true,
                    action: {
                        onAskMeLaterButton()
                        print("Ask me later")
                    }
                )
            }
        }
    }
}

struct RateUsPreviews: PreviewProvider {
    static var previews: some View {
        RateUsView(
            onAskMeLaterButton: {
                
            },
            onNotReallyButton: {
                
            },
            onLoveItButton: {
                
            })
        
    }
}

extension Color {
    /// ✅ Converts a 6-character Hex string to a SwiftUI `Color`
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Ensure hex string is valid
        guard hex.count == 6, let intVal = Int(hex, radix: 16) else {
            self = .gray // Default color if invalid hex
            return
        }
        
        // Extract RGB values
        let red = Double((intVal >> 16) & 0xFF) / 255.0
        let green = Double((intVal >> 8) & 0xFF) / 255.0
        let blue = Double(intVal & 0xFF) / 255.0
        
        self = Color(red: red, green: green, blue: blue)
    }
}

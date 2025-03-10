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
            VStack(spacing: -5) {
                Text("RATE US!")
                    .multilineTextAlignment(.center)
                    .font(.title).bold()
                    .lineSpacing(5)
                    .lineLimit(2)
                    .padding()
                
                Divider()
                    .frame(height: 1) // Adjust thickness
                    .background(Color.gray.opacity(0.3)) // Light gray color
                    .padding(.horizontal, 8) // Add padding to align with text
                                
                ZStack {
                    Image("Icon")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: 125,
                            height: 125
                        )
                    
                    Text("Enjoying Recipe Hub:\nMeal Planner Pro")
                        .foregroundStyle(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18).bold())
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .offset(y: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
            }
            
            Spacer()
                        
            VStack(spacing: -4) {
                
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
                    isUnderLined: true,
                    action: {
                        onAskMeLaterButton()
                        print("Ask me later")
                    }
                )
            }
        }
        .frame(maxHeight: 360)
        .background(Color(hex: "8CC76D"))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.7), radius: 3)
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

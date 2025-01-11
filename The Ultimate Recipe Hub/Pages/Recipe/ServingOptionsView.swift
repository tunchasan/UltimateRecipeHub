//
//  ServingOptionsView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct ServingOptionsView: View {
    @State private var selectedServing: String = "2 Serving" // Default selected value
    
    var addToPlanAction: () -> Void // Action to perform on button tap
    
    var body: some View {
        
        HStack(spacing: 20) {
            // Dropdown Button
            Menu {
                Button(action: { selectedServing = "1 Serving" }) {
                    Text("1 Serving")
                }
                Button(action: { selectedServing = "2 Servings" }) {
                    Text("2 Servings")
                }
                Button(action: { selectedServing = "3 Servings" }) {
                    Text("3 Servings")
                }
                Button(action: { selectedServing = "4 Servings" }) {
                    Text("4 Servings")
                }
                Button(action: { selectedServing = "5 Servings" }) {
                    Text("5 Servings")
                }
                Button(action: { selectedServing = "6 Servings" }) {
                    Text("6 Servings")
                }
            } label: {
                HStack {
                    Text(selectedServing) // Display the selected serving
                        .font(.system(size: 14).bold())
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .frame(maxWidth: 140, minHeight: 45)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.7), radius: 2)
            }
            
            // Second Rich Button
            RichButton(title: "Add to meal plan",
                       emoji: "",
                       backgroundColor: .green,
                       minHeight: 43,
                       emojiFontSize: 30,
                       titleFontSize: 14,
                       emojiColor: .white,
                       titleColor: .white,
                       useSystemImage: false,
                       action: { addToPlanAction() })
        }
        .padding([.top, .horizontal, .bottom])
        .background(Color.gray.opacity(0.075))
    }
}

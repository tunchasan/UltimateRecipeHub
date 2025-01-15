//
//  ServingOptionsView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct AddToMealPlanFooter: View {
    
    var action: () -> Void // Action to perform on button tap
    
    var body: some View {
        
        HStack(spacing: 20) {
            // Second Rich Button
            RichButton(title: "Add to meal plan",
                       emoji: "",
                       backgroundColor: .green,
                       minHeight: 43,
                       emojiFontSize: 30,
                       titleFontSize: 16,
                       emojiColor: .white,
                       titleColor: .white,
                       useSystemImage: false,
                       action: { action() })
        }
        .padding([.top, .horizontal, .bottom])
        .background(Color.gray.opacity(0.075))
    }
}

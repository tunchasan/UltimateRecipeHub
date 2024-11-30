//
//  SingleSelectionRichButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct SingleSelectionRichButton: View {
    var title: String
    var subTitle: String
    var emoji: String
    var defaultBackgroundColor: Color = .gray.opacity(0.1)
    var selectedBackgroundColor: Color = .green.opacity(0.4)
    var foregroundColor: Color = .black
    
    @Binding var isSelectable: Bool
    @State var isChecked: Bool = false
    var action: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            if isSelectable || isChecked {
                isChecked.toggle()
                action(isChecked)
            }
        })
        {
            HStack {
                Text(emoji)
                    .font(.title)
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline.bold())
                        .foregroundColor(foregroundColor)
                    
                    if !subTitle.isEmpty {
                        Text(subTitle)
                            .font(.caption)
                            .foregroundColor(foregroundColor)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(isChecked ? selectedBackgroundColor : defaultBackgroundColor)
            .cornerRadius(12)
            .scaleEffect(isChecked ? 1.075 : 1.0) // Slightly increase scale when checked
            .animation(.easeInOut, value: isChecked) // Smooth animation for transition
            .opacity(isSelectable || isChecked ? 1 : 0.5)
            .animation(.easeInOut, value: isSelectable) // Smooth animation for transition
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}

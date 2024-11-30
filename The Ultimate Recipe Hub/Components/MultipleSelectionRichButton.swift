//
//  RoundedRichButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct MultipleSelectionRichButton: View {
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
            if(isSelectable){
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
                
                if(isSelectable){
                    Image(systemName: isChecked ? "checkmark.circle" : "circle")
                        .font(.title2)
                        .foregroundColor(foregroundColor)
                        .padding(.horizontal, 10)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(isChecked ? selectedBackgroundColor : defaultBackgroundColor)
            .cornerRadius(12)
            .scaleEffect(isChecked ? 1.075 : 1.0) // Slightly increase scale when checked
            .animation(.easeInOut, value: isChecked) // Smooth animation for transition
            .opacity(isSelectable ? 1 : 0.5)
            .animation(.easeInOut, value: isSelectable) // Smooth animation for transition
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}

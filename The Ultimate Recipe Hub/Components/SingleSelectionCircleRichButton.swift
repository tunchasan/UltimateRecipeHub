//
//  SingleSelectionCircleRichButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct SingleSelectionCircleButton: View {
    var title: String
    var emoji: String
    var defaultBackgroundColor: Color = .gray.opacity(0.1)
    var selectedBackgroundColor: Color = .red.opacity(0.4)
    var foregroundColor: Color = .black
    
    @State private var isChecked: Bool = false
    var action: (Bool) -> Void
    
    var body: some View {
        
        VStack(spacing: 10) {
            Button(action: {
                isChecked.toggle()
                action(isChecked)
            }) {
                Text(emoji)
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(isChecked ? selectedBackgroundColor : defaultBackgroundColor)
            .cornerRadius(12)
            .scaleEffect(isChecked ? 1.075 : 1.0)
            .animation(.easeInOut, value: isChecked)
            
            Text(title)
                .font(.subheadline)
                .padding(.top, 2)
                .padding(.horizontal)
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}

struct MultipleSelectionRichButtonRed: View {
    var title: String
    var emoji: String
    var defaultBackgroundColor: Color = .gray.opacity(0.1)
    var selectedBackgroundColor: Color = .red.opacity(0.5)
    var foregroundColor: Color = .black
    
    @State var isChecked: Bool = false
    var action: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
            action(isChecked)
        })
        {
            HStack {
                Text(emoji)
                    .font(.title)
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(foregroundColor)
                }
                
                Spacer()
                
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
                    .font(.title2)
                    .foregroundColor(foregroundColor)
                    .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(isChecked ? selectedBackgroundColor : defaultBackgroundColor)
            .cornerRadius(12)
            .scaleEffect(isChecked ? 1.075 : 1.0)
            .animation(.easeInOut, value: isChecked)
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}

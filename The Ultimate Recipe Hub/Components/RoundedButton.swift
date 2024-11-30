//
//  RoundedButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 27.11.2024.
//

import SwiftUI

struct RoundedButton: View {
    var title: String
    var backgroundColor: Color = .green.opacity(0.9)
    var foregroundColor: Color = .white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(12)
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}

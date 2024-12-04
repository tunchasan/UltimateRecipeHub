//
//  RichButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 4.12.2024.
//

import SwiftUI

struct RichButton: View {
    var title: String
    var emoji: String
    var backgroundColor: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(emoji)
                    .font(.title)
                    .foregroundColor(.white) // Updated to white
                    .padding(.horizontal, 10)

                Text(title)
                    .font(.system(size: 14).bold())
                    .foregroundColor(.black) // Updated to white
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.7), radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

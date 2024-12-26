//
//  SearchTextField.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    var placeholder: String = "Enter URL"
    var buttonAction: () -> Void

    var body: some View {
        ZStack {
            // TextField
            TextField(placeholder, text: $text)
                .padding(.horizontal)
                .frame(height: 40)
                .font(.system(size: 14))
                .background(.green.opacity(0.1))
                .cornerRadius(12)
            
            // Button Overlap
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    buttonAction()
                }) {
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 3)
                        .font(.system(size: 24).bold())
                }
            }
        }
    }
}

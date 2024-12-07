//
//  RichButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 4.12.2024.
//

import SwiftUI

struct RichButton: View {
    var title: String
    var imageUrl: String
    var offsetY: CGFloat
    var action: () -> Void
    var height: CGFloat = 50
    var cornerRadius: CGFloat = 16

    var body: some View {
        Button(action: action) {
            ZStack {
                Image(imageUrl)
                    .resizable()
                    .offset(x: 0, y: offsetY)
                    .scaledToFill()
                    .frame(height: height) // Set height of the image
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                Text(title)
                    .font(.system(size: 18).bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.85), radius: 2)
            }
            .frame(height: height) // Ensure frame matches the interaction area
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // Ensure shape matches
        }
        .shadow(color: .black.opacity(0.7), radius: 2)
    }
}

struct RichButton_Previews: PreviewProvider {
    static var previews: some View {
        RichButton(
            title: "Easy Dinner",
            imageUrl: "Background2",
            offsetY: 2
        ) {
            print("Easy Dinner tapped")
        }
        .background(Color.gray.opacity(0.2)) // Optional preview background
    }
}

//
//  IconButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct IconButton: View {
    var systemImageName: String // Name of the system image
    var systemImageColor: Color = .green
    var size: CGFloat = 30 // Default size for the image
    var action: () -> Void      // Action to perform on tap

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.55).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
    }
}

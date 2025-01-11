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
    var minHeight: CGFloat = 40
    var maxWidth: CGFloat = .infinity
    var emojiFontSize: CGFloat = 32
    var titleFontSize: CGFloat = 14
    var emojiColor: Color = .white
    var titleColor: Color = .black
    var useSystemImage: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                
                if useSystemImage {
                    Image(systemName: emoji)
                        .font(.system(size: emojiFontSize).bold())
                        .foregroundColor(emojiColor)
                        .padding(.horizontal, 10)
                }
                
                else {
                    
                    if emoji != "" {
                        Text(emoji)
                            .font(.system(size: emojiFontSize).bold())
                            .foregroundColor(emojiColor) // Updated to white
                            .padding(.horizontal, 10)
                    }
                }
                
                Text(title)
                    .font(.system(size: titleFontSize).bold())
                    .foregroundColor(titleColor) // Updated to white   
                
                if useSystemImage || emoji != "" {
                    Spacer()
                }
            }
            .frame(maxWidth: maxWidth, minHeight: minHeight)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.5), radius: 2, x:1, y:2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RichText: View {
    var title: String
    var emoji: String
    var backgroundColor: Color = .white
    var minHeight: CGFloat = 40
    var maxWidth: CGFloat = .infinity
    var emojiFontSize: CGFloat = 32
    var titleFontSize: CGFloat = 14
    var emojiColor: Color = .white
    var titleColor: Color = .black
    var useSystemImage: Bool = false

    var body: some View {
        HStack {
            if useSystemImage {
                Image(systemName: emoji)
                    .font(.system(size: emojiFontSize).bold())
                    .foregroundColor(emojiColor)
                    .padding(.horizontal, 10)
            } else {
                if !emoji.isEmpty {
                    Text(emoji)
                        .font(.system(size: emojiFontSize).bold())
                        .foregroundColor(emojiColor)
                        .padding(.horizontal, 10)
                }
            }

            Text(title)
                .font(.system(size: titleFontSize).bold())
                .foregroundColor(titleColor)

            if useSystemImage || !emoji.isEmpty {
                Spacer()
            }
        }
        .frame(maxWidth: maxWidth, minHeight: minHeight)
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 2)
    }
}


struct IconTextButton: View {
    var systemImageName: String // Name of the system image
    var systemImageColor: Color = .blue
    var title: String           // Text to display under the image
    var titleColor: Color = .black
    var imageSize: CGFloat = 40 // Default size for the image
    var fontSize: CGFloat = 14  // Default font size for the text
    var maxWidth: CGFloat = .infinity
    var action: () -> Void      // Action to perform on tap

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundColor(systemImageColor) // Default color for the image
                
                Text(title)
                    .font(.system(size: fontSize))
                    .foregroundColor(titleColor) // Uses the default text color
                    .multilineTextAlignment(.center) // Center the text
            }
            .frame(maxWidth: maxWidth) // Optional: Makes the button stretch horizontally
        }
    }
}

struct RichTextButton: View {
    var title: String           // Text to display under the image
    var subTitle: String           // Text to display under the image

    var titleColor: Color = .black
    var subTitleColor: Color = .black

    var titleFontSize: CGFloat = 40  // Default font size for the text
    var subTitleFontSize: CGFloat = 14  // Default font size for the text

    var action: () -> Void      // Action to perform on tap

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: titleFontSize).bold())
                    .foregroundColor(titleColor) // Uses the default text color
                    .multilineTextAlignment(.center) // Center the text
                
                Text(subTitle)
                    .font(.system(size: subTitleFontSize))
                    .foregroundColor(subTitleColor) // Uses the default text color
                    .multilineTextAlignment(.center) // Center the text
            }
            .frame(maxWidth: .infinity) // Optional: Makes the button stretch horizontally
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
}

struct TextButton: View {
    var title: String
    var titleColor: Color = .black
    var titleFontSize: CGFloat = 40

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: titleFontSize).bold())
                .foregroundColor(titleColor) // Uses the default text color
                .multilineTextAlignment(.center) // Center the text
                .frame(maxWidth: .infinity, maxHeight: 50) // Optional: Makes the button stretch horizontally
        }
    }
}

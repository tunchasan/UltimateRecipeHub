//
//  RecipeCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.12.2024.
//

import SwiftUI

struct RecipeCard: View {
    var imageUrl: String
    var showProBadge: Bool = true
    var action: () -> Void
    
    var body: some View {
        VStack {
            
            ZStack {
                RoundedImage(imageUrl: imageUrl)
                
                RecipeAction(action: action, showProBadge: showProBadge)
                    .offset(x: 50, y: -30) // Adjust top-right alignment
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .scaleEffect(0.7)

                RecipeDifficulty()
                    .offset(x: -25, y: -25) // Adjust top-right alignment
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .scaleEffect(0.7)
                
                RecipeLink()
                    .offset(x: 17.5, y: 17.5) // Adjust top-right alignment
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .scaleEffect(0.75)
            }
            .frame(width: 100, height: 100) // Size of the RecipeCard
            
            Text("Summer Farro Salad")
                .font(.subheadline)
                .padding(.top, 25)
        }
    }
}

struct RecipeCard_Preview: PreviewProvider {
    static var previews: some View {
        RecipeCard(imageUrl: "https://images.food52.com/a7gj5nkQN9V8r7CcAu9me820qZY=/2016x1344/filters:format(webp)/fa4a2c19-ec5b-4b2b-a29d-3feb3850325c--2018-0712_summer-farro-salad_3x2_rocky-luten_021.jpg", action: {
            print("Button tapped!")
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

struct RecipeAction: View {
    var action: () -> Void // Action to perform on button tap
    var size: CGFloat = 35 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    var showProBadge: Bool = true // Visibility of the "Pro" badge
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // "Pro" Badge
                if showProBadge {
                    Text("PRO")
                        .padding(.trailing, 30)
                        .frame(width: size * 2.5, height: size)
                        .font(.system(size: size * 0.525))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(size / 2) // Rounded corners
                        .offset(x: -size * 0.75, y: 0)
                }
                
                Circle()
                    .fill(.white)
                    .frame(width: size, height: size)
                
                Text("+")
                    .font(.system(size: size * 0.9))
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.bottom, 6)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
    }
}

struct RecipeLink: View {
    var size: CGFloat = 30 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    var showProBadge: Bool = true // Visibility of the "Pro" badge
    
    var body: some View {
        Button(action: {}) {
            Text("food52.com")
                .frame(width: size * 4, height: size)
                .font(.system(size: size * 0.525))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(size / 2) // Rounded corners
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
    }
}

struct RoundedImage: View {
    var imageUrl: String
    var cornerRadius: CGFloat = 20
    var size: CGFloat = 150
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .shadow(color: .black.opacity(0.7), radius: 2)
            case .failure(_):
                Color.gray // Fallback for failed image loading
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            default:
                ProgressView() // Show progress view while loading
                    .frame(width: size, height: size)
            }
        }
    }
}

struct RecipeDifficulty: View {
    var size: CGFloat = 32.5 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: -3) {
                Image(systemName: "tuningfork")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 18))
                    .fontWeight(.bold)

                Image(systemName: "tuningfork")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 18))
                    .fontWeight(.bold)

                Image(systemName: "tuningfork")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .opacity(0.5)
            }
            .frame(width: size * 2.25, height: size) // Define frame size
            .background(backgroundColor)
            .cornerRadius(size / 2) // Rounded corners
            .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
    }
}

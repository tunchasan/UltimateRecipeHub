//
//  RecipeCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.12.2024.
//

import SwiftUI

struct RecipeCard: View {
    var title: String
    var imageUrl: String
    var showProBadge: Bool = true
    var difficulty = 3;
    var characterLimit: Int = 75 // Maximum number of characters to display
    var action: () -> Void
    
    var body: some View {
        VStack {
            
            ZStack {
                RoundedImage(imageUrl: imageUrl)
                
                RecipeAction(action: action, showProBadge: showProBadge)
                    .offset(x: 32.5, y: -32.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .scaleEffect(0.7)
                
                RecipeDifficulty(difficulty: difficulty)
                    .offset(x: -20, y: -50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .scaleEffect(0.7)
                
                RecipeLink()
                    .offset(x: 22.5, y: 22.5) // Adjust top-right alignment
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .scaleEffect(0.75)
            }
            
            Text(trimmedTitle)
                .padding(.top, 1)
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
                .frame(width: 160, height: 50, alignment: .topLeading) // Limit size and align
                .lineLimit(3) // Limit text to 2 lines
                .truncationMode(.tail) // Add "..." if text overflows
        }
        .frame(width: 170, height: 200) // Size of the RecipeCard
    }
    
    private var trimmedTitle: String {
        if title.count > characterLimit {
            return String(title.prefix(characterLimit)) + "..." // Trim and add "..."
        }
        return title
    }
}

struct RecipeCard_Preview: PreviewProvider {
    static var previews: some View {
        RecipeCard(title: "Lacinato Kale & Mint Salad With Spicy Peanut Dressing",
                   imageUrl: "https://images.food52.com/a7gj5nkQN9V8r7CcAu9me820qZY=/2016x1344/filters:format(webp)/fa4a2c19-ec5b-4b2b-a29d-3feb3850325c--2018-0712_summer-farro-salad_3x2_rocky-luten_021.jpg", action: {
            print("Button tapped!")
        })
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
            HStack(spacing: -30) {
                // "Pro" Badge
                if showProBadge {
                    Text("PRO")
                        .padding(.trailing, 25)
                        .frame(width: size * 2.5, height: size)
                        .font(.system(size: size * 0.525))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(size / 2) // Rounded corners
                }
                
                Image(systemName: "plus")
                    .font(.system(size: size * 0.6))
                    .fontWeight(.bold)
                
                    .foregroundColor(.black.opacity(0.7))
                    .padding(size * 0.24) // Add padding to make the circle larger than the icon
                    .background(Color.white) // Set the background color
                    .clipShape(Circle()) // Make the background circular
                    .shadow(radius: 5) // Optional shadow for aesthetics
                
            }
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
    }
}

struct RecipeLink: View {
    var size: CGFloat = 30// Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    var showProBadge: Bool = true // Visibility of the "Pro" badge
    
    var body: some View {
        Button(action: {}) {
            HStack {
                
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .padding(.bottom, 6)
                
                Text("food52.com")
                    .font(.system(size: size * 0.55))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 140, height: size)
        .background(Color.green.opacity(0.85))
        .shadow(color: .white.opacity(0.75), radius: 5) // White shadow
        .cornerRadius(size / 2) // Rounded corners
        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
    }
}

struct RoundedImage: View {
    var imageUrl: String
    var cornerRadius: CGFloat = 20
    var size: CGFloat = 172
    
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
    var difficulty = 3;
    var size: CGFloat = 20 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 4) {
                Image(systemName: "tuningfork")
                    .font(.system(size: size * 0.7))
                    .fontWeight(.bold)
                    .foregroundColor(foregroundColor)
                    .padding(size * 0.2) // Add padding to make the circle larger than the icon
                    .background(backgroundColor) // Set the background color
                    .clipShape(Circle()) // Make the background circular
                    .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
                
                if difficulty > 1 {
                    
                    Image(systemName: "tuningfork")
                        .font(.system(size: size * 0.7))
                        .fontWeight(.bold)
                        .foregroundColor(foregroundColor)
                        .padding(size * 0.2) // Add padding to make the circle larger than the icon
                        .background(backgroundColor) // Set the background color
                        .clipShape(Circle()) // Make the background circular
                        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
                }
                
                if difficulty > 2 {
                    
                    Image(systemName: "tuningfork")
                        .font(.system(size: size * 0.7))
                        .fontWeight(.bold)
                        .foregroundColor(foregroundColor)
                        .padding(size * 0.2) // Add padding to make the circle larger than the icon
                        .background(backgroundColor) // Set the background color
                        .clipShape(Circle()) // Make the background circular
                        .shadow(color: .white.opacity(0.8), radius: 5) // White shadow
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}

    import SwiftUI
    
    struct RecipeLink_Previews: PreviewProvider {
        static var previews: some View {
            RecipeLink()
                .previewLayout(.sizeThatFits)
                .background(Color.black) // Background for better visibility
        }
    }
    
    struct RoundedImage_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                RoundedImage(imageUrl: "https://via.placeholder.com/170")
                    .previewDisplayName("Image Loaded")
                    .previewLayout(.sizeThatFits)
                    .padding()
                
                RoundedImage(imageUrl: "invalid_url")
                    .previewDisplayName("Failed to Load")
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
            .background(Color.white) // Background for better contrast
        }
    }
    
    struct RecipeDifficulty_Previews: PreviewProvider {
        static var previews: some View {
            RecipeDifficulty()
                .previewLayout(.sizeThatFits)
                .background(Color.black) // Background for better shadow visibility
        }
    }

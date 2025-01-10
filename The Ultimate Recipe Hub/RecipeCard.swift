//
//  RecipeCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.12.2024.
//

import SwiftUI

struct RecipeTitle: View {
    var action: () -> Void // Action to perform on button tap
    var title: String
    var backgroundColor: Color = .green // Default background color
    
    var body: some View {
        
        Text(title)
            .padding(.vertical, 2)
            .padding(.horizontal, 10)
            .font(.system(size: 14).bold())
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.7), radius: 3)
    }
}

struct RecipeCard: View {
    var title: String
    var imageUrl: String
    var showProBadge: Bool = false
    var showFavoriteButton: Bool = false // Visibility of the Favorite button
    var scale: CGFloat = 1
    var action: () -> Void
        
    var body: some View {
        VStack {
                
            ZStack {
                NavigationLink(
                    destination: RecipeDetails(
                        imageName: title,
                        title: title
                    ).navigationBarTitleDisplayMode(.inline),
                    
                    label: {
                        RoundedImage(
                            imageUrl: imageUrl,
                            cornerRadius: 12,
                            action: {
                                action()
                            }
                        )
                    }
                )
                .buttonStyle(PlainButtonStyle())
                
                // Pro Badge
                if showProBadge {
                    RecipeAction(action: { })
                        .offset(x: 32.5, y: -32.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .scaleEffect(0.7)
                }
                
                // Favorite Button
                if showFavoriteButton {
                    Button(action: {
                        print("Favorite button tapped")
                    }) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                            .background(.white)
                            .padding(-3)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.8), radius: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: -5, y: -5) // Adjust position
                }
            }
            
            // Title
            Text(title)
                .padding(.top, 1)
                .font(.system(size: 12 * (1 - scale + 1)))
                .multilineTextAlignment(.leading)
                .frame(width: 160, height: 50, alignment: .topLeading) // Limit size and align
                .lineLimit(2) // Limit text to 2 lines
                .truncationMode(.tail) // Add "..." if text overflows
        }
        .frame(width: 170, height: 200) // Size of the RecipeCard
        .scaleEffect(scale)
    }
}


struct RecipeCard_Preview: PreviewProvider {
    static var previews: some View {
        RecipeCard(title: "No-Noodle Eggplant Lasagna with Mushroom Ragú",
                   imageUrl: "No-Noodle Eggplant Lasagna with Mushroom Ragú", showProBadge: true, action: {
            print("Button tapped!")
        })
    }
}

struct RecipeAction: View {
    var action: () -> Void // Action to perform on button tap
    var size: CGFloat = 35 // Default diameter for the button
    var backgroundColor: Color = .green // Default background color
    var foregroundColor: Color = .white // Default foreground color
    
    var body: some View {
        Text("PRO")
            .frame(width: size * 2, height: size)
            .font(.system(size: size * 0.55))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(size / 2) // Rounded corners
            .shadow(color: .white.opacity(0.8), radius: 2) // White shadow
    }
}

struct RoundedImage: View {
    var imageUrl: String
    var size: CGFloat = 172
    var heightFactor: CGFloat = 1
    var cornerRadius: CGFloat = 20
    var action: () -> Void
    
    var body: some View {
        Image(imageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size * heightFactor) // Exact size of the image
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.7), radius: 2)
    }
}

struct RecommendedPlanCardView: View {
    var imageUrl: String
    var action: () -> Void
    var width: CGFloat = 365
    var height: CGFloat = 200
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack{
            
            Button(action: action) {
                Image(imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height) // Exact size of the image
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .shadow(color: .black.opacity(0.7), radius: 2)
            }
            .buttonStyle(PlainButtonStyle()) // Ensure no padding or extra effects
            
            VStack(alignment: .leading, spacing: 28) { // Align content to the leading edge
                Text("RECOMMENDED PLANS")
                    .font(.system(size: 18).bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 2)
                
                Text("Perfect plans, \ncustomized for you.")
                    .font(.system(size: 25).bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 2)
                
                Text("See Meal Plans")
                    .font(.system(size: 14).bold())
                    .foregroundColor(.white)
                    .padding(5)
                    .background(.green)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.7), radius: 2)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Fill the width and align left
            .padding(.horizontal, 10) // Add padding to position text within the card
        }
        .frame(width: width, height: height) // Exact size of the image
    }
}

struct RecommendedPlanCardView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendedPlanCardView(imageUrl: "Test1", action: {})
    }
}

struct RoundedImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RoundedImage(imageUrl: "https://via.placeholder.com/170", action: {})
                .previewDisplayName("Image Loaded")
                .previewLayout(.sizeThatFits)
                .padding()
            
            RoundedImage(imageUrl: "invalid_url", action: {})
                .previewDisplayName("Failed to Load")
                .previewLayout(.sizeThatFits)
                .padding()
        }
        .background(Color.white) // Background for better contrast
    }
}

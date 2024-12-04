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
    var showProBadge: Bool = false
    var difficulty = 3;
    var characterLimit: Int = 75 // Maximum number of characters to display
    var action: () -> Void
    
    @State var isActionPopupOpen: Bool = false
    
    var body: some View {
        VStack {
            
            ZStack {
                
                RoundedImage(imageUrl: imageUrl, action: action)
                
                RecipeAction(action: { isActionPopupOpen = true }, showProBadge: showProBadge)
                    .offset(x: 32.5, y: -32.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .scaleEffect(0.7)
                
                if isActionPopupOpen {
                    RecipeActionPopupAlert {
                        isActionPopupOpen = false
                    }
                }
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
                        .font(.system(size: size * 0.5))
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

struct RecipeActionPopupAlert: View {
    @State private var showAlert = true // Automatically show the alert when this view appears
    
    var onCloseAction: () -> Void
    
    var body: some View {
        VStack {
            
        }
        .alert("Recipe Actions", isPresented: $showAlert) {
            Button("Add to Meal Plan", role: .none) {
                addToMealPlan()
            }
            Button("Add to Favorites", role: .none) {
                addToFavorites()
            }
            Button("Cancel", role: .cancel) {
                closeAlert()
            }
        } message: {
            Text("Choose an action for this recipe.")
        }
        .onAppear {
            // Automatically show the alert when the view appears
            showAlert = true
        }
    }
    
    // Placeholder actions
    func addToMealPlan() {
        onCloseAction()
        print("Add to meal plan action triggered.")
    }
    
    func addToFavorites() {
        onCloseAction()
        print("Add to favorites action triggered.")
    }
    
    func closeAlert() {
        onCloseAction()
        print("Alert closed.")
    }
}

struct RecipeActionPopupAlert_Previews: PreviewProvider {
    static var previews: some View {
        RecipeActionPopupAlert(onCloseAction: {})
    }
}

struct RecipeActionPopup: View{
    
    var onAddToPlanAction: () -> Void
    var onAddToFavoriAction: () -> Void
    var onCloseAction: () -> Void
    
    var body: some View {
        ZStack{
            
            VStack (spacing: 10) {
                
                Button(action: onAddToPlanAction){
                    Text("Add to meal plan")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                
                Button(action: onAddToFavoriAction){
                    Text("Add to favorities")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.white)
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .frame(width: 150, height: 100)
            .background(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            
            Button(action: onCloseAction){
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 21))
                    .fontWeight(.bold)
                    .foregroundColor(.red.opacity(0.8))
                    .background(Color.white) // Set the background color
                    .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .shadow(radius: 2)
            .offset(x: 7.5, y: -7.5)
        }
        .frame(width: 150, height: 100)
    }
}

struct RecipeActionPopup_Previews: PreviewProvider {
    static var previews: some View {
        RecipeActionPopup(
            onAddToPlanAction: {
                
            }, onAddToFavoriAction: {
                
            }, onCloseAction: {})
        .previewLayout(.sizeThatFits)
        .background(.gray)
    }
}

struct RoundedImage: View {
    var imageUrl: String
    var action: () -> Void
    var size: CGFloat = 172
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        Button(action: action) {
            Image(imageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size) // Exact size of the image
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(color: .black.opacity(0.7), radius: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Ensure no padding or extra effects
        .frame(width: size * 0.85, height: size) // Restrict the button's clickable area
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius)) // Ensure the clickable area matches the rounded image
    }
}

struct RecommendedPlanCardView: View {
    var imageUrl: String
    var action: () -> Void
    var width: CGFloat = 360
    var height: CGFloat = 180
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
            
            VStack(alignment: .leading, spacing: 24) { // Align content to the leading edge
                Text("RECOMMENDED PLANS")
                    .font(.system(size: 16).bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 2)
                
                Text("Perfect plans, \ncustomized for you.")
                    .font(.system(size: 24).bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 2)

                Text("See Meal Plans")
                    .font(.system(size: 12).bold())
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

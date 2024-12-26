//
//  RecommendedPlanCardView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI

struct SaveExternalSourceCardView<Destination: View>: View {
    var imageUrl: String
    var content: String
    var destination: Destination
    var width: CGFloat = 365
    var height: CGFloat = 120
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        NavigationLink(destination: destination.navigationBarTitleDisplayMode(.inline)) {
            ZStack {
                // Background Image
                Image(imageUrl)
                    .resizable()
                    .scaledToFill()
                    .offset(y: 25)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .shadow(color: .black.opacity(0.7), radius: 2)
                    .contentShape(RoundedRectangle(cornerRadius: cornerRadius)) // Match tappable area to visible shape
                
                // Text Content
                VStack(alignment: .leading, spacing: 20) {
                    Text(content)
                        .font(.system(size: 21).bold())
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.7), radius: 2)
                    
                    Text("See Collection")
                        .font(.system(size: 14).bold())
                        .foregroundColor(.white)
                        .padding(5)
                        .background(.green)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.7), radius: 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            }
            .frame(width: width, height: height)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius)) // Ensure the entire shape is tappable
        }
        .buttonStyle(PlainButtonStyle()) // Remove default NavigationLink styling
    }
}

struct SaveExternalRecipeCardView_Preview: PreviewProvider {
    static var previews: some View {
        SaveExternalSourceCardView(
            imageUrl: "Test1",
            content: "Add your favorite recipes \nfrom the web",
            destination: Text("Mock Destination View"))
    }
}

//
//  SeeAllCard.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 12.01.2025.
//

import SwiftUI

struct SeeAllCard: View {
    
    var scale: CGFloat = 1
        
    var body: some View {
        
        VStack {
            
            RoundedImage (
                imageUrl: "Test1",
                cornerRadius: 12,
                action: { })
            
            Text("See All Recipes")
                .padding(.top, 1)
                .font(.system(size: 12 * (1 - scale + 1)))
                .multilineTextAlignment(.leading)
                .frame(width: 160, height: 50, alignment: .topLeading) // Limit size and align
                .truncationMode(.tail) // Add "..." if text overflows
        }
        .frame(width: 170, height: 200) // Size of the RecipeCard
        .scaleEffect(scale)
    }
}

struct SeeAllCard_Previews: PreviewProvider {
    static var previews: some View {
        SeeAllCard()
    }
}

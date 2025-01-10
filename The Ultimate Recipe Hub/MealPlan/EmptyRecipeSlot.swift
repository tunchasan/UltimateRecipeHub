//
//  EmptyRecipeSlot.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct EmptyRecipeSlot: View {
    var title: String
    var action: () -> Void // Action to perform when the button is tapped
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: "plus")
                    .font(.system(size: 40))
                    .foregroundColor(.green.opacity(0.7))
                
                Image("Test1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 235) // Size of the button
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(0.1)
                
                Text(title)
                    .font(.system(size: 14).bold())
                    .foregroundColor(.gray)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(width: 170, height: 235) // Size of the button
        }
        .buttonStyle(PlainButtonStyle()) // Ensures no extra padding or effects
    }
}

struct EmptyRecipeSlot_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRecipeSlot(title: "Breakfast") {
            print("Empty slot tapped")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

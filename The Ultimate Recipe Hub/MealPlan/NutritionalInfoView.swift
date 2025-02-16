//
//  NutritionalInfoView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct NutritionalInfoView: View {
    var macros: Macros = Macros(carbs: 0, protein: 0, fat: 0)
    var calories: Int = 0
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        HStack(spacing: 10) {
            RichTextButton(
                title: "\(calories)",
                subTitle: "Calories",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
            
            RichTextButton(
                title: "\(macros.protein)gr",
                subTitle: "Protein",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
            RichTextButton(
                title: "\(macros.carbs)gr",
                subTitle: "Carb",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
            RichTextButton(
                title: "\(macros.fat)gr",
                subTitle: "Fat",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.075))
        .cornerRadius(cornerRadius)
        .padding(.horizontal, 10)
    }
}

struct NutritionalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionalInfoView()
    }
}

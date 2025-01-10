//
//  NutritionalInfoView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct NutritionalInfoView: View {
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        HStack(spacing: 10) {
            RichTextButton(
                title: "2340",
                subTitle: "Calories",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
            
            RichTextButton(
                title: "50gr",
                subTitle: "Protein",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
            RichTextButton(
                title: "200gr",
                subTitle: "Carb",
                titleColor: .green,
                titleFontSize: 20,
                action: {
                    print("Favorites tapped")
                }
            )
            RichTextButton(
                title: "120gr",
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
        .background(Color.gray.opacity(0.1))
        .cornerRadius(cornerRadius)
        .padding(.horizontal, 10)
    }
}

struct NutritionalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionalInfoView()
    }
}

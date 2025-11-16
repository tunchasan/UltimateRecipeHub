//
//  RoundedButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.03.2025.
//

import SwiftUI

struct PaywallButton: View {
    var title: String
    var badgeText: String = ""
    var subTitle: String
    var priceText: String
    var periodText: String = ""
    var discountText: String = ""
    var isSelected: Bool = false
    var backgroundColor: Color = .black.opacity(0.8)
    var foregroundColor: Color = .white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack (spacing: 10) {
                        Text(title)
                            .font(.system(size: 16).bold())
                        
                        if !badgeText.isEmpty {
                            Text(badgeText)
                                .font(.system(size: 12).bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(.purple)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(subTitle)
                        .font(.system(size: 13).bold())
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    
                    HStack {
                        if !discountText.isEmpty {
                            Text(discountText)
                                .font(.system(size: 14))
                                .foregroundStyle(.orange)
                                .strikethrough()
                        }
                        
                        Text(priceText)
                            .font(.system(size: 15).bold())
                    }
                    
                    if !periodText.isEmpty {
                        Text(periodText)
                            .font(.system(size: 13))
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .frame(height: 65)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green.opacity(isSelected ? 1 : 0), lineWidth: 3)
            )
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PaywallButton(
        title: "Monthly",
        badgeText: "3 days free",
        subTitle: "$1.99/month",
        priceText: "$1.99",
        periodText: "per month",
        discountText: "23.99"
    ) {
        
    }
}

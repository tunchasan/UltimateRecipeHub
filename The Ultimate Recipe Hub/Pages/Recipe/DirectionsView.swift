//
//  DirectionsView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct DirectionsView: View {
    var ingredientKeywords: [String]
    @State var directions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title for Directions Section
            Text("Directions")
                .font(.title3.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Steps List
            ForEach(directions.indices.dropLast(), id: \.self) { index in
                HStack(alignment: .firstTextBaseline) {
                    // Step Number
                    Text("\(index + 1)")
                        .font(.subheadline.bold())
                        .foregroundColor(.black)
                        .frame(width: 25, height: 25) // Circle size
                        .background(
                            Circle()
                                .fill(Color.green.opacity(0.2)) // White background
                        )
                    
                    // Step Description with Highlighted Keywords
                    Text(highlightKeywords(in: directions[index], using: ingredientKeywords))
                        .font(.system(size: 16))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                }
                .padding(.horizontal)
            }
        }
    }

    private func highlightKeywords(in sentence: String, using keywords: [String]) -> AttributedString {
        var attributedString = AttributedString(sentence)
        let keywordWords = keywords.flatMap { $0.split(separator: " ").map(String.init) }

        for keyword in keywordWords {
            if let range = attributedString.range(of: keyword, options: .caseInsensitive) {
                attributedString[range].foregroundColor = .orange
                attributedString[range].font = .system(size: 16).bold()
            }
        }

        return attributedString
    }
}

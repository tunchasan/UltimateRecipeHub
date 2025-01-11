//
//  RecipeTagGridView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct RecipeTagGridView: View {
    var tags: [String]
    
    // Adaptive grid layout
    let columns = [GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10)]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("TAGS")
                .font(.system(size: 14).bold())
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Ingredients Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12).italic())
                        .foregroundColor(.black)
                        .padding(.horizontal, 5)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background(.yellow.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
        }
        .padding(.vertical)
    }
}

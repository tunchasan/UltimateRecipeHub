//
//  MultiTitledHeader.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct MultiTitledHeader: View {
    var title: String
    var subTitle: String = ""

    var body: some View {
        
        
        if !subTitle.isEmpty {
            Text(subTitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

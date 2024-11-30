//
//  MultiTitledHeader.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.11.2024.
//

import SwiftUI

struct MultiTitledHeader: View {
    var title: String
    var subTitle: String

    var body: some View {
        
        Text(title)
            .font(.title)
            .bold()
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 2)
        
        Text(subTitle)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom)
    }
}

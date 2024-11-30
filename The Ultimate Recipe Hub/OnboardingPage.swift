//
//  OnboardingPage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 27.11.2024.
//

import Foundation
import SwiftUI

struct OnboardingPageContent: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

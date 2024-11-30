//
//  SegmentedProgressBar.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 27.11.2024.
//

import Foundation
import SwiftUI

struct SegmentedProgressBar: View {
    var currentStep: Int
    let totalSteps: Int = 4
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .fill(index < currentStep ? Color.green.opacity(0.8) : Color.gray.opacity(0.3))
                    .frame(height: 6)
                    .cornerRadius(3)
            }
        }
        .padding(.horizontal)
    }
}

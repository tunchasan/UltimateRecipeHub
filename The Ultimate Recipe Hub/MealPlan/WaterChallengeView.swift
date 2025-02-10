//
//  WaterChallengeView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct WaterChallengeView: View {
    let cornerRadius: CGFloat = 8.0

    var body: some View {
        VStack(spacing: 10) {
            Text("Water Challenge")
                .font(.system(size: 18).bold())
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .padding(.horizontal, 5)
            
            WaterProgressView()

            Text("2L")
                .font(.system(size: 24).bold())
                .foregroundStyle(.black.opacity(0.6))
            
            Text("Daily Goal")
                .font(.system(size: 16).bold())
                .foregroundStyle(.black.opacity(0.6))
        }
    }
}

struct WaterChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        WaterChallengeView()
    }
}

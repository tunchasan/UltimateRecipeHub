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

            Text("Goal 2L")
                .font(.system(size: 16))

            Text("0.8L")
                .font(.system(size: 24).bold())

            HStack(spacing: 20) {
                Image(systemName: "waterbottle.fill")
                    .font(.system(size: 40))

                Image(systemName: "waterbottle.fill")
                    .font(.system(size: 40))

                Image(systemName: "waterbottle")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray)

                Image(systemName: "waterbottle")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray)

                Image(systemName: "waterbottle")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)
        }
    }
}

struct WaterChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        WaterChallengeView()
    }
}

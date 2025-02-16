//
//  WaterChallengeView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//
import SwiftUI
import ConfettiSwiftUI

struct WaterChallengeView: View {
    var date: Date
    var challenge: WaterChallengeEntry
    let cornerRadius: CGFloat = 8.0
    @State private var progress: CGFloat
    @State private var triggerConfetti: Int = 0

    init(challenge: WaterChallengeEntry, date: Date) {
        self.date = date
        self.challenge = challenge
        _progress = State(initialValue: challenge.progress) // Set initial progress
    }

    var body: some View {
        VStack(spacing: 10) {
            // Title
            Text("Water Challenge")
                .font(.system(size: 18).bold())
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .padding(.horizontal, 5)

            // Water Progress Bar
            WaterProgressView(
                onComplete: handleCompletion,
                progress: $progress
            )

            // Goal Display
            VStack(spacing: 2) {
                Text("\(challenge.goal)L")
                    .font(.system(size: 24).bold())
                    .foregroundStyle(.black.opacity(0.6))
                
                Text("Daily Goal")
                    .font(.system(size: 16).bold())
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
        .confettiCannon(trigger: $triggerConfetti, repetitions: 3, repetitionInterval: 0.7)
        .onChange(of: progress) {
            oldValue,
            newValue in
            MealPlanManager.shared.updateWaterChallengeProgress(
                for: date,
                with: newValue,
                in: challenge.goal
            )
        }
    }

    private func handleCompletion() {
        triggerConfetti += 1
    }
}

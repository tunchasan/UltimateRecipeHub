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
    @State private var challenge: WaterChallengeEntry
    let cornerRadius: CGFloat = 8.0
    @State private var triggerConfetti: Int = 0
    private let mealPlanner = MealPlanManager.shared

    init(challenge: WaterChallengeEntry, date: Date) {
        self.date = date
        _challenge = State(initialValue: challenge) // Store challenge as state
    }

    var body: some View {
        VStack(spacing: 2) {
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
                goal: challenge.goal,
                progress: challenge.alphaProgress(),
                onIncrease: { increaseProgress() },
                onDecrease: { decreaseProgress() }
            )

            // Goal Display
            VStack(spacing: 5) {
                Text("%\(String(format: "%.0f", challenge.alphaProgress() * 100)) completed")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                
                Text("\(formatGoal(challenge.goal))L Daily Goal")
                    .font(.system(size: 20).bold())
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
        .confettiCannon(trigger: $triggerConfetti, repetitions: 3, repetitionInterval: 0.7)
    }

    private func handleCompletion() {
        triggerConfetti += 1
    }

    private func increaseProgress() {
        let newProgress = min(challenge.progress + 0.2, challenge.goal)
        updateChallengeProgress(newProgress)
    }

    private func decreaseProgress() {
        let newProgress = max(challenge.progress - 0.2, 0)
        updateChallengeProgress(newProgress)
    }

    private func updateChallengeProgress(_ newProgress: CGFloat) {
        challenge.progress = newProgress
        mealPlanner.updateWaterChallengeProgress(for: date, with: newProgress, in: challenge.goal)
        if newProgress >= challenge.goal {
            handleCompletion()
        }
    }

    /// Formats the goal to remove unnecessary decimals (e.g., "2.0" -> "2", "2.2" -> "2.2")
    private func formatGoal(_ goal: CGFloat) -> String {
        return goal.truncatingRemainder(dividingBy: 1) == 0 ?
            String(format: "%.0f", goal) : // No decimal if whole number
            String(format: "%.1f", goal)   // One decimal place if fractional
    }
}

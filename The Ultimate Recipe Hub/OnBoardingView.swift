//
//  OnBoardingView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.12.2024.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var path: [Int] = []
    @StateObject private var user = User.shared
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                OnboardingMealPlanPage {
                    path.append(1)
                }
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: Int.self) { step in
                    content(for: step)
                }
            }
        }
        .tint(.green)
        .onAppear() {
            if user.isOnBoardingCompleted {
                path.append(7)
            }
        }
    }

    /// Helper to determine the destination view based on the step
    @ViewBuilder
    func content(for step: Int) -> some View {
        switch step {
        case 1:
            OnboardingHealtyMealPage {
                path.append(2) // Push to the next step
            }
            .navigationBarBackButtonHidden(true)
        case 2:
            OnboardingAICoachPage {
                path.append(3) // Push to the next step
            }
            .navigationBarBackButtonHidden(true)
        case 3:
            OnboardingGoalPage {
                path.append(4) // Push to the next step
            }
        case 4:
            OnboardingPreferencesPage {
                path.append(5) // Push to the next step
            }
        case 5:
            OnboardingCookingSkillPage {
                path.append(6) // Push to the next step
            }
        case 6:
            OnboardingSensitivityPage {
                path.append(7) // Push to the next step
            }
        default:
            HomeView()
        }
    }
}

#Preview {
    OnBoardingView()
}

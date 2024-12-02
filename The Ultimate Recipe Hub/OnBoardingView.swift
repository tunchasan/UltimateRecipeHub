//
//  OnBoardingView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.12.2024.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var path: [Int] = [] // Tracks navigation steps
    @StateObject private var user = User.shared
    
    var body: some View {
        // Use NavigationStack for onboarding flow
        NavigationStack(path: $path) {
            VStack {
                OnboardingGoalPage {
                    withAnimation {
                        path.append(2) // Push to the next step
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Int.self) { step in
                    content(for: step)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        SegmentedProgressBar(currentStep: 1)
                            .frame(maxWidth: 300)
                            .padding()
                    }
                }
            }
        }
        .tint(.green).opacity(0.8)
        .onAppear() {
            if user.isOnBoardingCompleted {
                path.append(5) // You can also navigate to another screen if necessary
            }
        }
    }

    
    /// Helper to determine the destination view based on the step
    @ViewBuilder
    func content(for step: Int) -> some View {
        switch step {
        case 2:
            OnboardingPreferencesPage {
                withAnimation {
                    path.append(3) // Push to the next step
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SegmentedProgressBar(currentStep: 2)
                        .frame(maxWidth: 300)
                        .padding(.trailing, 30)
                }
            }
        case 3:
            OnboardingCookingSkillPage {
                withAnimation {
                    path.append(4) // Push to the next step
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SegmentedProgressBar(currentStep: 3)
                        .frame(maxWidth: 300)
                        .padding(.trailing, 30)
                }
            }
        case 4:
            OnboardingSensitivityPage {
                withAnimation {
                    path.append(5) // Push to the next step
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SegmentedProgressBar(currentStep: 4)
                        .frame(maxWidth: 300)
                        .padding(.trailing, 30)
                }
            }
        default:
            HomeView()
        }
    }
}

#Preview {
    OnBoardingView()
}

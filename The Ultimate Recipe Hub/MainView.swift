//
//  ContentView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.11.2024.
//

import SwiftUI

struct MainView: View {
    @State private var path: [Int] = [] // Tracks navigation steps
    
    var body: some View {
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
    }
    
    /// Helper to determine the destination view based on the step
    @ViewBuilder
    func content(for step: Int) -> some View {
        switch step {
        case 2:
            OnboardingDietPage {
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
                print("Onboarding Complete")
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
            EmptyView()
        }
    }
}

#Preview {
    MainView()
}

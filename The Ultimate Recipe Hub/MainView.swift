//
//  ContentView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.11.2024.
//

import SwiftUI
import AlertToast

struct MainView: View {
    @ObservedObject private var toastVisibilityManager = ToastVisibilityManager.shared
    @ObservedObject private var loadingVisibilityManager = LoadingVisibilityManager.shared
    @ObservedObject private var paywallVisibilityManager = PaywallVisibilityManager.shared
    @ObservedObject private var rateUsPrePromptVisibilityManager = RateUsPrePromptVisibilityManager.shared
    @ObservedObject private var user = User.shared
    @State private var homeOpacity: Double = 0

    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            if user.isOnBoardingCompleted {
                HomeView()
                    .opacity(homeOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            homeOpacity = 1
                        }
                    }
            } else {
                OnBoardingView()
            }
            
            if loadingVisibilityManager.isVisible {
                LoadingView()
            }
            
            if rateUsPrePromptVisibilityManager.isVisible {
                Color.gray.opacity(0.8)
                    .ignoresSafeArea()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: user.isOnBoardingCompleted)
        .sheet(isPresented: $paywallVisibilityManager.isVisible) {
            NewPaywallView(directory: paywallVisibilityManager.triggerSource)
                .interactiveDismissDisabled(true)
        }
        .toast(isPresenting: $toastVisibilityManager.isVisible, duration: 2, offsetY: 5){
            if toastVisibilityManager.subMessage != "" {
                return AlertToast(
                    displayMode: .hud,
                    type: toastVisibilityManager.type == .success ? .systemImage("checkmark.circle.fill", .green) : .systemImage("x.circle.fill", .red),
                    title: toastVisibilityManager.message,
                    subTitle: toastVisibilityManager.subMessage
                )
            }
            
            return AlertToast(
                displayMode: .hud,
                type: toastVisibilityManager.type == .success ? .systemImage("checkmark.circle.fill", .green) : .systemImage("x.circle.fill", .red),
                title: toastVisibilityManager.message
        )}
        .sheet(isPresented: $rateUsPrePromptVisibilityManager.isVisible) {
            RateUsView(
                onAskMeLaterButton: {
                    RateUsPrePromptVisibilityManager.hide()
                },
                onNotReallyButton: {
                    RateUsPrePromptVisibilityManager.hide()
                },
                onLoveItButton: {
                    RateUsPrePromptVisibilityManager.hide()
                    presentReview()
                }
            )
            .presentationDetents([.fraction(0.315)]) // Set height to 40%
            .presentationBackground(Color.white) // Ensure background is solid
            .presentationCornerRadius(25) // Apply rounded corners only to the top
        }
    }
    
    /// Presents the rating and review request view after a two-second delay.
    private func presentReview() {
        Task {
            // Delay for two seconds to avoid interrupting the person using the app.
            try await Task.sleep(for: .seconds(2))
            requestReview()
        }
    }
}

#Preview {
    MainView()
}

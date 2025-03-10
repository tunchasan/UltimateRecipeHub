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

            // ✅ Centered RateUsView Popup
            if rateUsPrePromptVisibilityManager.isVisible {
                ZStack {
                    // ✅ Dimmed Background
                    Color.gray.opacity(0.8)
                        .ignoresSafeArea()
                        
                    // ✅ Popup View
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
                    .transition(.scale.combined(with: .opacity)) // ✅ Smooth transition
                }
                .animation(.easeInOut(duration: 0.3), value: rateUsPrePromptVisibilityManager.isVisible) // ✅ Fade-in animation
            }
        }
        .animation(.easeInOut(duration: 0.5), value: user.isOnBoardingCompleted)
        .sheet(isPresented: $paywallVisibilityManager.isVisible) {
            NewPaywallView(directory: paywallVisibilityManager.triggerSource)
                .interactiveDismissDisabled(true)
        }
        .toast(isPresenting: $toastVisibilityManager.isVisible, duration: 2, offsetY: 5){
            
            //Choose .hud to toast alert from the top of the screen
            AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", .green), title: toastVisibilityManager.message)
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

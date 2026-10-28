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
    @ObservedObject private var ratingPrompt = RatingPromptManager.shared
    @ObservedObject private var user = User.shared
    @State private var homeOpacity: Double = 0
    /// App-open logo animation. MainView is created once per cold launch, so it plays only then, never when
    /// the app comes back from the background.
    @State private var showLaunchAnimation = true
    
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

            if showLaunchAnimation {
                LaunchAnimationView {
                    showLaunchAnimation = false
                    ratingPrompt.isLaunchAnimationShowing = false
                    // Asked after the animation so the system alert doesn't cover it (no-op once answered).
                    NotificationManager.shared.requestNotificationPermission()
                }
                .zIndex(100)
            }

        }
        .animation(.easeInOut(duration: 0.5), value: user.isOnBoardingCompleted)
        .sheet(isPresented: $paywallVisibilityManager.isVisible) {
            NewPaywallView(directory: paywallVisibilityManager.triggerSource)
                .interactiveDismissDisabled(true)
        }
        .fullScreenCover(isPresented: $paywallVisibilityManager.isFullScreenVisible) {
            NewPaywallView(directory: paywallVisibilityManager.triggerSource)
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
        // Apple's rating prompt, at the moments RatingPromptManager picks (it already waited for a calm moment).
        .onChange(of: ratingPrompt.requestCount) { _, _ in
            requestReview()
        }
    }
}

#Preview {
    MainView()
}

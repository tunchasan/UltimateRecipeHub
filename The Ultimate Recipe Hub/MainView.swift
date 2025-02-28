//
//  ContentView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.11.2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var loadingVisibilityManager = LoadingVisibilityManager.shared
    @ObservedObject private var paywallVisibilityManager = PaywallVisibilityManager.shared
    @ObservedObject private var user = User.shared
    @State private var homeOpacity: Double = 0

    var body: some View {
        ZStack {
            
            if user.isOnBoardingCompleted {
                HomeView()
                    .opacity(homeOpacity) // Apply opacity animation to HomeView
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            homeOpacity = 1 // Fade in HomeView
                        }
                    }
                
            }
            
            else {
                OnBoardingView()
            }
            
            if loadingVisibilityManager.isVisible {
                LoadingView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: user.isOnBoardingCompleted) // Smooth transition when switching
        .sheet(isPresented: $paywallVisibilityManager.isVisible, onDismiss: {
        }) {
            NewPaywallView(directory: paywallVisibilityManager.triggerSource)
                .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    MainView()
}

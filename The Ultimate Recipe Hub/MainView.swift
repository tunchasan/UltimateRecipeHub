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
            PaywallView(directory: paywallVisibilityManager.triggerSource)
                .presentationDetents([.fraction(0.4)]) // Set height to 40%
                .presentationBackground(Color.white) // Ensure background is solid
                .presentationCornerRadius(25) // Apply rounded corners only to the top
        }
    }
}

#Preview {
    MainView()
}

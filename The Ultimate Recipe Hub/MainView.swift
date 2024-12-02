//
//  ContentView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.11.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var user = User.shared
    
    var body: some View {
        Group {
            if user.isOnBoardingCompleted {
                // Show a clear view with no navigation
                HomeView()
                    .padding()
            } else {
                OnBoardingView()
            }
        }
    }
}

#Preview {
    MainView()
}

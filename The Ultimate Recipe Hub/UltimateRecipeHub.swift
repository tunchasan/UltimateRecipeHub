//
//  The_Ultimate_Recipe_HubApp.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.11.2024.
//

import SwiftUI
import RevenueCat

@main
struct UltimateRecipeHub: App {
    
    init() {
        Purchases.logLevel = .debug // ✅ Enables RevenueCat logs (for debugging)
        
        DispatchQueue.main.async {
            Purchases.configure(withAPIKey: "appl_gGQunHiPconAwirYcKmqDNMaQtf") // ✅ Ensures setup on main thread
            SubscriptionManager.shared.checkProStatus() // ✅ Prevents UI updates on background thread
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
                .onAppear {
                    NotificationManager.shared.requestNotificationPermission()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    NotificationManager.shared.scheduleNotifications()
                }
            
        }
    }
}

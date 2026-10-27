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
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        #if DEBUG
        Purchases.logLevel = .debug // ✅ RevenueCat logs in Xcode builds only; release keeps the SDK default
        #endif
        
        DispatchQueue.main.async {
            #if DEBUG
            // Xcode builds sign in as one fixed test customer, so simulator runs and reinstalls don't
            // create a new anonymous customer each time (those count as New/Active Customers in RevenueCat).
            // Passed as a String (not a literal): RevenueCat warns on literal IDs to catch accidental shared IDs; this one is deliberate.
            let debugCustomerID: String = "debug-xcode-tester"
            Purchases.configure(withAPIKey: "appl_gGQunHiPconAwirYcKmqDNMaQtf", appUserID: debugCustomerID)
            #else
            Purchases.configure(withAPIKey: "appl_gGQunHiPconAwirYcKmqDNMaQtf") // ✅ Ensures setup on main thread
            #endif
            // Apple Ads attribution (standard data, no ATT prompt needed): trials and purchases per campaign/keyword in RevenueCat.
            Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
            SubscriptionManager.shared.checkProStatus() // ✅ Prevents UI updates on background thread
            SubscriptionManager.shared.fetchProducts()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
                .onChange(of: scenePhase, { oldValue, newValue in
                    if newValue == .background {
                        NotificationManager.shared.scheduleNotifications()
                    }
                })
            
        }
    }
}

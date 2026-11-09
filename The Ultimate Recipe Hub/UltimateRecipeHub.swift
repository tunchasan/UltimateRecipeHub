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
        // Launch argument "-UnitsSelfCheck YES": converts every recipe ingredient in both unit systems and prints oddities
        DispatchQueue.global(qos: .utility).async { UnitConverter.runSelfCheckIfAsked() }
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
                    // Back in the foreground: check Pro again, so a purchase on another device, a refund
                    // or a wrong "free" reading heals without relaunching. RevenueCat answers from its
                    // cache when it's fresh, so this is cheap. Skipped until RevenueCat is set up at launch.
                    // (Coming back goes background → inactive → active, so this checks on every .active.)
                    if newValue == .active && Purchases.isConfigured {
                        SubscriptionManager.shared.checkProStatus()
                    }
                })
            
        }
    }
}

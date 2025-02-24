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
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_gGQunHiPconAwirYcKmqDNMaQtf")
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
        }
    }
}

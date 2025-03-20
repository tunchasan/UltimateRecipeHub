//
//  RateUsPrePromptVisibilityManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.03.2025.
//

import SwiftUI

class RateUsPrePromptVisibilityManager: ObservableObject {
    
    static let shared = RateUsPrePromptVisibilityManager()
    
    @Published var isVisible = false {
        didSet {
            if isVisible {
                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
                UserDefaults.standard.set(true, forKey: "hasSeenRateUsPopup")  // ✅ Save that popup was shown
                UserDefaults.standard.set(currentVersion, forKey: "rateUsPopupVersion")  // ✅ Save app version
            }
        }
    }

    private init() {
        print("hasSeenRateUsPopup:: \(UserDefaults.standard.bool(forKey: "hasSeenRateUsPopup")) :: rateUsPopupVersion:: \(String(describing: UserDefaults.standard.string(forKey: "rateUsPopupVersion")))")
    }
    
    /// ✅ Checks if the RateUs popup should be shown
    static func shouldShowPopup() -> Bool {
        let hasShown = UserDefaults.standard.bool(forKey: "hasSeenRateUsPopup")
        let lastShownVersion = UserDefaults.standard.string(forKey: "rateUsPopupVersion") ?? "Never"
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return !hasShown || lastShownVersion != currentVersion
    }
    
    /// ✅ Hides the popup
    static func hide() {
        if shared.isVisible {
            withAnimation {
                shared.isVisible = false
            }
        }
    }

    /// ✅ Shows the popup only if it hasn't been shown for the current app version
    static func show(after delay: TimeInterval = 1) {
        if !shared.isVisible && shouldShowPopup() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { // ✅ Delay execution
                withAnimation {
                    shared.isVisible = true
                }
            }
        }
    }
}

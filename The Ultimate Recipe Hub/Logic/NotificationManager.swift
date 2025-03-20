//
//  NotificationManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 20.03.2025.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {} // Prevent external instantiation
    
    /// ✅ Requests notification permission from the user.
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification Permission Error: \(error.localizedDescription)")
            } else {
                print("✅ Notification Permission Granted: \(granted)")
            }
        }
    }
    
    func scheduleNotifications() {
        schedule_D0_30_Minutes_After_Notification()
        schedule_D1_11_15_Notification()
        schedule_D1_17_50_Notification()
        schedule_D2_17_50_Notification()
        schedule_D3_17_50_Notification()
        schedule_D7_11_15_Notification()
    }
    
    /// 📌 Trigger 30 minutes later
    func schedule_D0_30_Minutes_After_Notification() {
        let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledNotification_D0_30")
        
        guard !hasScheduled else { return } // Prevent duplicate scheduling
        
        let content = UNMutableNotificationContent()
        content.title = "Meal Prep Made Easy! 🥗"
        content.body = "A little prep today makes healthy eating effortless all week long!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1800, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification_D0_30", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Scheduling Error: \(error.localizedDescription)")
            } else {
                print("✅ Notification_D0_30 Scheduled!")
                UserDefaults.standard.set(true, forKey: "hasScheduledNotification_D0_30") // Mark as scheduled
            }
        }
    }
    
    /// 📌 Trigger Tomorrow (D1) at 11:15 AM
    func schedule_D1_11_15_Notification() {
        let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledNotification_D1_11_15")
        
        guard !hasScheduled else { return } // Prevent duplicate scheduling
        
        let content = UNMutableNotificationContent()
        content.title = "Boost Your Energy Naturally! ⚡"
        content.body = "Did you know eating protein in the morning helps you stay full longer? Try a high-protein breakfast today!"
        content.sound = .default
        
        var dateComponentsD1_11_15 = Calendar.current.dateComponents([.year, .month, .day], from: Date().addingTimeInterval(86400)) // D1 (Tomorrow)
        dateComponentsD1_11_15.hour = 11
        dateComponentsD1_11_15.minute = 15

        let triggerD1_11_15 = UNCalendarNotificationTrigger(dateMatching: dateComponentsD1_11_15, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification_D1_11_15", content: content, trigger: triggerD1_11_15)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Scheduling Error: \(error.localizedDescription)")
            } else {
                print("✅ D1_11_15_Notification Scheduled!")
                UserDefaults.standard.set(true, forKey: "hasScheduledNotification_D1_11_15") // Mark as scheduled
            }
        }
    }
    
    /// 📌 Trigger Tomorrow (D1) at 17:50 PM
    func schedule_D1_17_50_Notification() {
        let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledNotification_D1_17_50")
        
        guard !hasScheduled else { return } // Prevent duplicate scheduling
        
        let content = UNMutableNotificationContent()
        content.title = "What’s for Dinner Tonight? 🍽️"
        content.body = "Let us plan it for you! Check out a quick and delicious recipe now."
        content.sound = .default
        
        var dateComponentsD1_17_50 = Calendar.current.dateComponents([.year, .month, .day], from: Date().addingTimeInterval(86400)) // D1 (Tomorrow)
        dateComponentsD1_17_50.hour = 17
        dateComponentsD1_17_50.minute = 50

        let triggerD1_17_50 = UNCalendarNotificationTrigger(dateMatching: dateComponentsD1_17_50, repeats: false)
        let request = UNNotificationRequest(identifier: "notification_D1_17_50", content: content, trigger: triggerD1_17_50)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Scheduling Error: \(error.localizedDescription)")
            } else {
                print("✅ D1_17_50_Notification Scheduled!")
                UserDefaults.standard.set(true, forKey: "hasScheduledNotification_D1_17_50") // Mark as scheduled
            }
        }
    }
    
    /// 📌 Trigger D2 (Day After Tomorrow) at 17:50 PM
    func schedule_D2_17_50_Notification() {
        let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledNotification_D2_17_50")
        
        guard !hasScheduled else { return } // Prevent duplicate scheduling
        
        let content = UNMutableNotificationContent()
        content.title = "Cooking Made Simple! 👨‍🍳"
        content.body = "A few ingredients, one pan, and dinner is served. Tap to see how!"
        content.sound = .default
        
        var dateComponentsD2_17_50 = Calendar.current.dateComponents([.year, .month, .day], from: Date().addingTimeInterval(172800)) // D2 (Day After Tomorrow)
        dateComponentsD2_17_50.hour = 17
        dateComponentsD2_17_50.minute = 50

        let triggerD2_17_50 = UNCalendarNotificationTrigger(dateMatching: dateComponentsD2_17_50, repeats: false)
        let request = UNNotificationRequest(identifier: "notification_D2_17_50", content: content, trigger: triggerD2_17_50)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Scheduling Error: \(error.localizedDescription)")
            } else {
                print("✅ D2_17_50_Notification Scheduled!")
                UserDefaults.standard.set(true, forKey: "hasScheduledNotification_D2_17_50") // Mark as scheduled
            }
        }
    }
    
    /// 📌 Trigger D3 at 17:50 PM
    func schedule_D3_17_50_Notification() {
        let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledNotification_D3_17_50")
        
        guard !hasScheduled else { return } // Prevent duplicate scheduling
        
        let content = UNMutableNotificationContent()
        content.title = "New Recipe Alert! 🚀"
        content.body = "A fresh, healthy recipe is waiting for you. Tap to discover!"
        content.sound = .default
        
        var dateComponentsD3_17_50 = Calendar.current.dateComponents([.year, .month, .day], from: Date().addingTimeInterval(259200)) // D3 (Three Days Later)
        dateComponentsD3_17_50.hour = 17
        dateComponentsD3_17_50.minute = 50

        let triggerD3_17_50 = UNCalendarNotificationTrigger(dateMatching: dateComponentsD3_17_50, repeats: false)
        let request = UNNotificationRequest(identifier: "notification_D3_17_50", content: content, trigger: triggerD3_17_50)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Scheduling Error: \(error.localizedDescription)")
            } else {
                print("✅ D3_17_50_Notification Scheduled!")
                UserDefaults.standard.set(true, forKey: "hasScheduledNotification_D3_17_50") // Mark as scheduled
            }
        }
    }
    
    /// 📌 Trigger D7 at 11:15 AM
    func schedule_D7_11_15_Notification() {
        let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledNotification_D7_11_15")
        
        guard !hasScheduled else { return } // Prevent duplicate scheduling
        
        let content = UNMutableNotificationContent()
        content.title = "Out of Ideas? 🤯"
        content.body = "Check out this week’s meal plan and never stress about food again!"
        content.sound = .default
        
        var dateComponentsD7_11_15 = Calendar.current.dateComponents([.year, .month, .day], from: Date().addingTimeInterval(604800)) // D7 (One Week Later)
        dateComponentsD7_11_15.hour = 11
        dateComponentsD7_11_15.minute = 15

        let triggerD7_11_15 = UNCalendarNotificationTrigger(dateMatching: dateComponentsD7_11_15, repeats: false)
        let request = UNNotificationRequest(identifier: "notification_D7_11_15", content: content, trigger: triggerD7_11_15)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Scheduling Error: \(error.localizedDescription)")
            } else {
                print("✅ D7_11_15_Notification Scheduled!")
                UserDefaults.standard.set(true, forKey: "hasScheduledNotification_D7_11_15") // Mark as scheduled
            }
        }
    }
}

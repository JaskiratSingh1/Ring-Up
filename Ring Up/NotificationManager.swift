/*
 The purpose of this file is to handle notifications.
 It handles requesting for notification autherization, scheduling notifications, and deleting them.
 */

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Request notification authorization from the user
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    /// Schedule a local notification for a specific ringUp
    func scheduleNotification(for ringUp: RingUp) {
        removeScheduledNotification(for: ringUp)
        
        // Create content
        let content = UNMutableNotificationContent()
        content.title = "Remember to reach out!"
        content.body = "It's time to talk to \(ringUp.name) on \(ringUp.platform)."
        content.sound = .default
        
        // Extract year, month, day, hour, minute from ringUp.nextReminderDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                 from: ringUp.nextReminderDate)
        
        // Decide if the notification repeats based on frequency
        // For demonstration:
        //  - daily: repeats every day (ignores year/month/day, but uses hour/minute)
        //  - weekly: repeats every week (ignores year/month/day, uses weekday/hour/minute)
        //  - monthly/yearly/custom: you’ll need more custom logic.
        
        var dateComponents = components
        var repeats = false
        
        switch ringUp.frequency {
        case .daily:
            // For daily repeating, ignore the year/month/day, use hour/minute only
            dateComponents = DateComponents(hour: components.hour, minute: components.minute)
            repeats = true
        case .weekly:
            // For weekly repeating, also capture the weekday
            // e.g., if nextReminderDate is a Wednesday, keep that
            let weekday = calendar.component(.weekday, from: ringUp.nextReminderDate)
            dateComponents = DateComponents(hour: components.hour, minute: components.minute, weekday: weekday)
            repeats = true
        case .monthly:
            // For monthly repeating, keep day of month + hour/minute
            dateComponents = DateComponents(day: components.day, hour: components.hour, minute: components.minute)
            repeats = true
        case .yearly:
            // For yearly repeating, keep month/day + hour/minute
            dateComponents = DateComponents(month: components.month, day: components.day,
                                            hour: components.hour, minute: components.minute)
            repeats = true
        case .customMonths:
            // Harder to schedule repeating. For demonstration, schedule one-time only.
            // You could dynamically re-schedule next time after the notification fires.
            repeats = false
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: ringUp.id.uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Remove a scheduled notification for a ringUp
    func removeScheduledNotification(for ringUp: RingUp) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [ringUp.id.uuidString]
        )
    }
}

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
        
        // Extract hour/minute from ringUp.reminderTime
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: ringUp.reminderTime)
        let minute = calendar.component(.minute, from: ringUp.reminderTime)
        
        // Create trigger – for demonstration, we do daily.
        // If you want more dynamic scheduling (weekly, monthly, etc.), you will need more advanced logic.
        // For now, let's schedule a repeating trigger daily at that time.
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(identifier: ringUp.id.uuidString, content: content, trigger: trigger)
        
        // Schedule
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

import SwiftUI
import Combine

class RingUpManager: ObservableObject {
    @Published var ringUps: [RingUp] = []
    
    /// Adds a new ringUp or updates an existing one
    func saveRingUp(_ ringUp: RingUp) {
        if let index = ringUps.firstIndex(where: { $0.id == ringUp.id }) {
            // Update existing
            ringUps[index] = ringUp
        } else {
            // Add new
            ringUps.append(ringUp)
        }
        
        // Schedule (or reschedule) local notification
        NotificationManager.shared.scheduleNotification(for: ringUp)
    }
    
    /// Deletes a ringUp
    func deleteRingUp(_ ringUp: RingUp) {
        ringUps.removeAll(where: { $0.id == ringUp.id })
        
        // Remove scheduled notification
        NotificationManager.shared.removeScheduledNotification(for: ringUp)
    }
    
    /// Returns ringUps grouped by frequency.
    /// If you need more complex grouping (e.g., daily, weekly, monthly, 3 months, 6 months, etc.),
    /// adapt this to handle custom intervals.
    func groupedRingUps() -> [Frequency: [RingUp]] {
        var dict: [Frequency: [RingUp]] = [:]
        
        for freq in Frequency.allCases {
            dict[freq] = ringUps.filter { $0.frequency == freq }
        }
        
        return dict
    }
}

import SwiftUI

/// Represents how often the reminder occurs.
enum Frequency: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case customMonths = "Every X Months"
    case yearly = "Yearly"
    
    var id: String { self.rawValue }
}

/// The main model for a "RingUp" reminder
struct RingUp: Identifiable, Equatable {
    let id: UUID
    var name: String
    var platform: String  // e.g., "Discord", "WhatsApp", etc.
    var frequency: Frequency
    var customMonthInterval: Int?  // For the "Every X Months" option
    var reminderTime: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        platform: String,
        frequency: Frequency,
        customMonthInterval: Int? = nil,
        reminderTime: Date
    ) {
        self.id = id
        self.name = name
        self.platform = platform
        self.frequency = frequency
        self.customMonthInterval = customMonthInterval
        self.reminderTime = reminderTime
    }
}

struct RingUpPreview: View {
    let reminder = RingUp(name: "Aspen", platform: "Messenger", frequency: .monthly, reminderTime: Date())
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name: \(reminder.name)")
                .font(.headline)
            Text("Platform: \(reminder.platform)")
                .font(.subheadline)
            Text("Frequency: \(reminder.frequency.rawValue)")
                .font(.subheadline)
            Text("Reminder Time: \(DateFormatter.localizedString(from: reminder.reminderTime, dateStyle: .medium, timeStyle: .short))")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    RingUpPreview()
}

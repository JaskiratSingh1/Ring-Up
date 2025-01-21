import SwiftUI

struct AddOrEditRingUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var ringUpManager: RingUpManager
    var ringUp: RingUp? = nil  // If nil, we’re creating a new one
    
    @State private var name: String = ""
    @State private var platform: String = ""
    @State private var frequency: Frequency = .weekly
    @State private var customMonthInterval: Int = 3
    
    /// The user's chosen next date/time for the reminder
    @State private var nextReminderDate: Date = Date()
    
    let platforms = ["Discord", "WhatsApp", "Telegram", "Messages", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Contact Info") {
                    // Import contact button
                    Button("Import from Contacts") {
                        // Implement your CNContactPicker or similar
                        // Then fill in the name/phone automatically
                    }
                    
                    TextField("Name", text: $name)
                    
                    Picker("Platform", selection: $platform) {
                        ForEach(platforms, id: \.self) { p in
                            Text(p).tag(p)
                        }
                    }
                }
                
                Section("Reminder Frequency") {
                    Picker("Frequency", selection: $frequency) {
                        ForEach(Frequency.allCases) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                    
                    // If user chooses "Every X Months"
                    if frequency == .customMonths {
                        Stepper("Every \(customMonthInterval) months", value: $customMonthInterval, in: 1...12)
                    }
                }
                
                Section("Next Reminder Date & Time") {
                    DatePicker("Next Reminder", selection: $nextReminderDate, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "en_US_POSIX"))
                }
                
                Section {
                    Button(ringUp == nil ? "Create" : "Save") {
                        save()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Delete button if editing
                    if let existingRingUp = ringUp {
                        Button("Delete", role: .destructive) {
                            ringUpManager.deleteRingUp(existingRingUp)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle(ringUp == nil ? "New Ring Up" : "Edit Ring Up")
            .onAppear {
                if let existingRingUp = ringUp {
                    name = existingRingUp.name
                    platform = existingRingUp.platform
                    frequency = existingRingUp.frequency
                    if let customInterval = existingRingUp.customMonthInterval {
                        customMonthInterval = customInterval
                    }
                    nextReminderDate = existingRingUp.nextReminderDate
                } else {
                    // If creating new, default nextReminderDate to tomorrow at 9 AM, for example
                    var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                    comps.hour = 9
                    comps.minute = 0
                    nextReminderDate = Calendar.current.date(from: comps) ?? Date()
                }
            }
        }
    }
    
    private func save() {
        let newRingUp = RingUp(
            id: ringUp?.id ?? UUID(),
            name: name,
            platform: platform,
            frequency: frequency,
            customMonthInterval: frequency == .customMonths ? customMonthInterval : nil,
            nextReminderDate: nextReminderDate
        )
        
        ringUpManager.saveRingUp(newRingUp)
        dismiss()
    }
}
/*
#Preview {
    // Sample data for preview
    let sampleReminder = RingUp(
        name: "Aspen",
        platform: "Messenger",
        frequency: .monthly,
        reminderTime: Date()
    )
    
    // View to display the sample data
    VStack(alignment: .leading, spacing: 10) {
        Text("Name: \(sampleReminder.name)")
            .font(.headline)
        Text("Platform: \(sampleReminder.platform)")
            .font(.subheadline)
        Text("Frequency: \(sampleReminder.frequency.rawValue)")
            .font(.subheadline)
        Text("Reminder Time: \(sampleReminder.reminderTime.formatted(date: .abbreviated, time: .shortened))")
            .font(.subheadline)
    }
    .padding()
}
*/

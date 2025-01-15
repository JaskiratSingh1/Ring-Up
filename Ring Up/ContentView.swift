import SwiftUI

struct ContentView: View {
    @StateObject private var ringUpManager = RingUpManager()
    @State private var showingAddNew = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                // We’ll group by frequency
                let grouped = ringUpManager.groupedRingUps()
                
                VStack(alignment: .leading) {
                    ForEach(Frequency.allCases) { freq in
                        if let ringUpsForFreq = grouped[freq], !ringUpsForFreq.isEmpty {
                            Text(freq.rawValue)
                                .font(.headline)
                                .padding(.leading)
                                .padding(.top, 8)
                            
                            ForEach(ringUpsForFreq) { ringUp in
                                NavigationLink(
                                    destination: AddOrEditRingUpView(ringUpManager: ringUpManager, ringUp: ringUp)
                                ) {
                                    HStack {
                                        // Use the platform icon if you want:
                                        // Image(ringUp.platform.lowercased())
                                        //     .resizable()
                                        //     .frame(width: 24, height: 24)
                                        
                                        Text(ringUp.name)
                                            .font(.body)
                                        Spacer()
                                        Text(ringUp.platform)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ring Up")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNew.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Color.pink.opacity(0.7)) // example pastel color
                            .padding(8)
                            .background(Circle().fill(Color.pink.opacity(0.2)))
                    }
                }
            }
            .sheet(isPresented: $showingAddNew) {
                // Present AddOrEditRingUpView with no initial ringUp
                AddOrEditRingUpView(ringUpManager: ringUpManager)
            }
        }
        .onAppear {
            // Request notification permission once the app appears
            NotificationManager.shared.requestAuthorization()
        }
    }
}

#Preview {
    ContentView()
}

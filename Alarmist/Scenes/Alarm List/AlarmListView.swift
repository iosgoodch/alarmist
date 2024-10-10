//
//  AlarmListView.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import SwiftUI

struct AlarmListView: View {
    
    @State private var viewModel = ViewModel()
    @State private var isNewAlarmSheetPresented: Bool = false
    @State private var isErrorPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Alarms")
                .toolbar {
                    Button {
                        isNewAlarmSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .padding(.trailing, 4.0)
                }
        }
        .task {
            await fetchAlarmList()
        }
        .alert("Alarm!", isPresented: $viewModel.alarmHasTriggered) {
            Button("Stop", role: .cancel) {
                /// Stop playing the sound
                viewModel.stopAlarm()
            }
        } message: {
            if let alarm = viewModel.activeAlarm {
                Text("\(alarm.alarmSound.displayName) is playing...")
            }
        }
        .alert("Unable to fetch alarm data!", isPresented: $isErrorPresented) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $isNewAlarmSheetPresented) {
            AlarmPickerView(viewModel: $viewModel)
                .presentationDetents([.height(230.0), .medium])
        }
    }
    
    var content: some View {
        List {
            ForEach($viewModel.alarmList, id: \.self.id) { $alarm in
                AlarmView(alarm: $alarm)
            }
            .onDelete(perform: viewModel.deleteAlarm)
        }
        .listStyle(.plain)
        .refreshable {
            await fetchAlarmList()
        }
    }
    
    @ViewBuilder
    private func alarmView(_ alarm: Alarm) -> some View {
        HStack(spacing: 12.0) {
            if let fireDate = alarm.fireDate {
                VStack(alignment: .leading) {
                    Text(fireDate.relativeTitle())
                        .font(.system(size: 10.0))
                    Text(alarm.displayString)
                        .font(.system(size: 28.0))
                        .bold()
                    Text("\(fireDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 8.0))
                }
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20.0))
                    .foregroundColor(.red)
                Text("Bad Alarm")
                    .bold()
            }
            Spacer()
            Text("\(alarm.alarmSound.displayIcon)")
                .font(.system(size: 20.0))
                .if(alarm.isRemote) { view in
                    view
                        .overlay {
                            Image(systemName: "cloud")
                                .font(.system(size: 12.0))
                                .offset(x: -32.0, y: 7.0)
                        }
                }
        }
        .padding(.vertical, 4.0)
    }
    
    private func fetchAlarmList() async {
        await withDiscardingTaskGroup { group in
            group.addTask {
                do {
                    try await viewModel.fetchAlarmList()
                } catch {
                    isErrorPresented.toggle()
                }
            }
        }
    }
    
}

/// Adding an extension to the AlarmListView and creating the 
/// ViewModel within allows for easier testing of the view model.
extension AlarmListView {
    
    @Observable
    class ViewModel {
        
        /// Boolean used to inform the UI layer that an alarm has been triggered.
        var alarmHasTriggered: Bool = false
        /// An array of current alarms.
        var alarmList: [Alarm]
        
        /// The current triggered alarm (optional)
        private(set) var activeAlarm: Alarm?
        
        /// An array of active timers.
        private var timerList: [Timer]
        
        init() {
            /// Initialize empty arrays of alarms and timers.
            self.alarmList = [Alarm]()
            self.timerList = [Timer]()
        }
        
        /// Used to fetch alarms from the backend.
        func fetchAlarmList() async throws {
            let endpoint = AlarmService.Endpoint.fetchAlarmList.rawValue
            let url = BaseService().url(route: endpoint)
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let remoteAlarms: RemoteAlarms = try decoder.decode(RemoteAlarms.self, from: data)
            if !remoteAlarms.alarms.isEmpty {
                append(alarms: remoteAlarms.alarms, deleteRemotes: true)
            }
        }
        
        /// Helper function to add a new alarm locally.
        /// - Parameters:
        ///   - date: The date of the alarm.
        ///   - sound: The sound to play when the alarm is triggered.
        func addLocalAlarm(withDate date: Date, sound: SoundType) {
            /// Initialize a new Alarm struct and convert the date to
            /// a timestamp so that the fireDate can be populated.
            let newAlarm = LocalAlarm(timestamp: date.toTimestamp(), soundType: sound)
            /// Add the new alarm to the alarmList array.
            append(alarms: newAlarm)
        }
        
        /// Used to delete an alarm.
        /// - Parameter offset: The index set of the alarm to be deleted.
        func deleteAlarm(at offset: IndexSet) {
            alarmList.remove(atOffsets: offset)
            generateTimers()
        }
        
        /// Used to stop the current alarm from playing.
        func stopAlarm() {
            AlarmAudioManager.shared.stopPlaying()
            activeAlarm = nil
            /// The fireDate of the current alarm will now be in the future.
            /// Rebuild the timers so it they are all up to date.
            generateTimers()
        }
        
        /// Private function that appends an alarm to the alarmList array.
        /// - Parameters:
        ///   - alarms: An array of alarms to add. Note, for a single alarm, the variadic function below is called instead.
        ///   - deleteRemotes: Pass in true if you want to delete remote alarms. Defaults to false.
        private func append(alarms: [Alarm], deleteRemotes: Bool = false) {
            /// Delete remote alarms from the array if necessary.
            if deleteRemotes {
                alarmList.removeAll(where: { $0.isRemote == true })
            }
            var allAlarms: [Alarm] = self.alarmList
            allAlarms.append(contentsOf: alarms)
            /// Sort all of the alarms in ascending time order.
            allAlarms = allAlarms.sorted {
                $0.sortString < $1.sortString
            }
            /// Now add load the alarms into the observed array which will cause the UI to refresh.
            alarmList = allAlarms
            /// Build the timers that will trigger based on the fireDate of each alarm.
            generateTimers()
        }
        
        /// Private function that appends an alarm to the alarmList array.
        /// - Parameters:
        ///   - alarms: Variadic list of alarms to be added to the alarmList array.
        ///   - deleteRemotes: Pass in true if you want to delete remote alarms. Defaults to false.
        private func append(alarms: Alarm..., deleteRemotes: Bool = false) {
            append(alarms: alarms, deleteRemotes: deleteRemotes)
        }
        
        /// Builds an array of timers that trigger on the exact date of the alarm.
        private func generateTimers() {
            /// Loop through all timers in the array (if any) and invalidate them.
            for timer in timerList {
                timer.invalidate()
            }
            /// Clear out the timer array.
            timerList.removeAll()
            /// Loop through all alrams and add a timer for each.
            for alarm in alarmList {
                if let date = alarm.fireDate {
                    /// Timers use an exact date. This is better than adding a 1 second
                    /// repeating timer that checks for alarm trigger times.
                    let timer = Timer(fireAt: date,
                                      interval: 0,
                                      target: self,
                                      selector: #selector(timerFired),
                                      userInfo: alarm.id, /// The id of the alarm will be used to determine which alarm was triggered.
                                      repeats: false)
                    /// Add the timer to the main run loop.
                    RunLoop.main.add(timer, forMode: .common)
                    /// Add the new timer to the timer array.
                    timerList.append(timer)
                }
            }
        }
        
        /// Function called when a timer fires.
        /// - Parameter timer: The timer that triggered the function call.
        @objc private func timerFired(timer: Timer) {
            if let id = timer.userInfo as? UUID, let alarm = alarmWith(id: id) {
                /// Store the active alarm for UI purposes (if needed).
                activeAlarm = alarm
                /// Toggle the observed bool value to cause the alert UI to be shown.
                alarmHasTriggered.toggle()
                /// Try to play the sound associated with the triggered alarm.
                do {
                    try AlarmAudioManager.shared.play(sound: alarm.alarmSound.rawValue)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        /// Helper function to retrieve an alarm by ID.
        /// - Parameter id: The identifier of the alarm to be retrieved.
        /// - Returns: An optional Alarm object.
        private func alarmWith(id: UUID) -> Alarm? {
            let alarm = alarmList.filter( { $0.id == id }).first
            return alarm
        }
        
    }
    
}

/// This is a simple way to expose the private properties for testing purposes.
#if DEBUG
extension AlarmListView.ViewModel {
    
    /// For testing only! Do not use in production code!
    /// - Returns: The array of Timer objects
    public func exposedTimerList() -> [Timer] {
        return self.timerList
    }
    
}
#endif

#Preview {
    AlarmListView()
}

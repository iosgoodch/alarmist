//
//  LocalAlarm.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

/// Local alarm data model that conforms to the Alarm protocol.
struct LocalAlarm: Alarm, Identifiable {
    
    let id: UUID = UUID()
    let timestamp: String
    let recurring: Bool
    let alarmSound: SoundType
    let isRemote: Bool = false
    
    private let sound: String
    
    /// The initializer for local alarms.
    /// - Parameters:
    ///   - timestamp: A string representing the moment an alarm will fire.
    ///   - soundType: The sound that will play when the alarm goes off.
    init(timestamp: String, soundType: SoundType) {
        self.timestamp = timestamp
        self.sound = soundType.rawValue
        self.recurring = true
        self.alarmSound = soundType
    }
    
}

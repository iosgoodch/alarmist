//
//  RemoteAlarm.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

/// Data model to hold decoded array of remote alarm models.
struct RemoteAlarms: Codable {
    
    let alarms: [RemoteAlarm]
    
    /// Mock data for building previews when actual data is unavailable.
    static var mockObjects: RemoteAlarms? {
        guard
            let url = Bundle.main.url(forResource: "MockAlarms", withExtension: "json")
        else {
            fatalError()
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(RemoteAlarms.self, from: data)
            return jsonData
        } catch {
            print("Error decoding mock data: \(error)")
        }
        return nil
    }
    
}

/// Remote alarm data model that conforms to the Alarm protocol.
struct RemoteAlarm: Alarm, Codable, Identifiable {
    
    let id: UUID = UUID()
    let timestamp: String
    let recurring: Bool
    let alarmSound: SoundType
    let isRemote: Bool = true
    
    private let sound: String
    
    /// The coding keys enum. Not always needed, unless the model contains
    /// additional values that are not included in the decoding process. In this case,
    /// we only care about decoding timestamp, sound, and recurring.
    enum CodingKeys: String, CodingKey {
        case timestamp
        case sound
        case recurring
    }
    
    /// The initializer used when decoding alarms from JSON
    /// - Parameter decoder: The decoder to be used.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.sound = try container.decode(String.self, forKey: .sound)
        self.recurring = try container.decode(Bool.self, forKey: .recurring)
        /// Convert the alarm sound into a sound type enum value.
        self.alarmSound = SoundType(rawValue: (self.sound)) ?? .alarmClock
    }
    
}

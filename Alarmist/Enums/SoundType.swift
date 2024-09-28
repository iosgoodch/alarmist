//
//  SoundType.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

/// Enumeration of soundtypes that map to the backend values and provide new local values.
/// Each enum includes a display name and a display icon.
enum SoundType: String, CaseIterable {
    case alarmClock = "alarm-clock"
    case birdSong = "birds"
    case brownNoise = "brown-noise"
    case oceanWaves = "ocean"
    case whiteNoise = "white-noise"
    
    var displayName: String {
        switch self {
        case .alarmClock:
            "Alarm Clock"
        case .birdSong:
            "Bird Song"
        case .brownNoise:
            "Brown Noise"
        case .oceanWaves:
            "Ocean Waves"
        case .whiteNoise:
            "White Noise"
        }
    }
    
    var displayIcon: String {
        switch self {
        case .alarmClock:
            "⏰"
        case .birdSong:
            "🎶"
        case .brownNoise:
            "🟤"
        case .oceanWaves:
            "🌊"
        case .whiteNoise:
            "⚪️"
        }
    }
}

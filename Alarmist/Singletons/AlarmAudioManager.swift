//
//  AlarmAudioManager.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import AVFoundation

enum SoundError: Error {
    // Throw when a sound cannot be played
    case cannotPlaySound

    // Throw when an expected resource is not found
    case fileNotFound

    // Throw in all other cases
    case unexpected(code: Int)
}

extension SoundError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .cannotPlaySound:
            return "Unable to play the specified sound file."
        case .fileNotFound:
            return "The specified sound file could not be found."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
    
}

class AlarmAudioManager {
    
    /// Define a singleton that can be referenced from anywhere.
    static let shared = AlarmAudioManager()
    /// The stored AVAudioPlayer
    private var alarmSound: AVAudioPlayer?
    
    /// On init, set up the AVAudioSession and make it active.
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Unable to start AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    /// Used to play a sound.
    /// - Parameter sound: The name of the sound to play.
    func play(sound: String) throws {
        guard let soundFileURL = Bundle.main.url(forResource: sound, withExtension: "wav") else {
            throw SoundError.fileNotFound
        }
        do {
            alarmSound = try AVAudioPlayer(contentsOf: soundFileURL)
            alarmSound?.numberOfLoops = -1 // Inifinite loop.
            alarmSound?.play()
        } catch {
            throw SoundError.cannotPlaySound
        }
    }
    
    /// Used to stop playing the current sound.
    func stopPlaying() {
        alarmSound?.stop()
        alarmSound = nil
    }
    
}

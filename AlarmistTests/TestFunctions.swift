//
//  TestFunctions.swift
//  AlarmistTests
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

/// These functions are to be used in testing. They should return the same results as the Date extensions.

struct TestFunctions {
    
    static let testTimestamp = "2026-09-22T17:07:51+0000"
    
    static func generateSortString() -> String {
        guard let date = testTimestamp.toDate() else {
            return ""
        }
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.hour, .minute], from: date)
        if let hours = components.hour, let minutes = components.minute {
            /// Create a string with leading zero padding for hours and minutes.
            /// Examples: "1034", "0830", and "1705"
            return String(format: "%02d%02d", hours, minutes)
        } else {
            return ""
        }
    }
    
    static func generateDisplayString() -> String {
        guard let date = testTimestamp.toDate() else {
            return ""
        }
        return date.formatted(date: .omitted, time: .shortened)
    }
    
}

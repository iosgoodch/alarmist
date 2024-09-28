//
//  Date+Utilities.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

extension Date {
    
    /// Date extension to generate a UTC time stamp for each alarm.
    /// - Returns: A string representation of the date as UTC.
    func toTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = Constants.dateFormat
        let timestamp = formatter.string(from: self)
        return timestamp
    }
    
    /// Date extension to generate a relative date title for each alarm.
    /// - Returns: A string representing the relative date.
    func relativeTitle() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        let formatted = formatter.string(from: self)
        return formatted + " at:"
    }
    
    /// Date extension to generate a sort string for each alarm.
    /// - Returns: A string representing the hours and minutes of a date with zero padding.
    func toSortString() -> String {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.hour, .minute], from: self)
        if let hours = components.hour, let minutes = components.minute {
            /// Create a string with leading zero padding for hours and minutes.
            /// Examples: "1034", "0830", and "1705"
            return String(format: "%02d%02d", hours, minutes)
        } else {
            return ""
        }
    }
    
    /// Date extension to generate a formatted time string for each alarm.
    /// - Returns: A string representing the formatted hours and minutes of a date. Example: "3:08 PM".
    func toDisplayString() -> String {
        return self.formatted(date: .omitted, time: .shortened)
    }
    
    /// Date extension to zero out the seconds of a date without rounding.
    /// - Returns: A date with the seconds set to zero.
    func stripSeconds() -> Date {
        let calendar = Calendar.autoupdatingCurrent
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.second = 0
        guard let date = calendar.date(from: components) else {
            return self
        }
        return date
    }
    
}

//
//  String+Utilities.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import SwiftUI

extension String {
    
    /// String extension to convert UTC timestamp strings into Date objects
    /// - Returns: An optional Date object
    func toDate() -> Date? {
        /// Convert the string date format to a Date
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = Constants.dateFormat
        guard let date = formatter.date(from: self) else {
            return nil
        }
        
        let calendar = Calendar.autoupdatingCurrent
        /// Extract the hours, minutes, and seconds from the alarm date
        let alarmComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        /// Save the alarm seconds for rounding up
        let alarmSeconds = alarmComponents.second ?? 0
        /// Extract the year, month, and day from the current date
        var currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        /// Replace the current day hour and minute to the alarm values
        currentComponents.hour = alarmComponents.hour
        /// Increase the minute by 1 if the seconds were >= 30
        currentComponents.minute = (alarmComponents.minute ?? 0) + (alarmSeconds >= 30 ? 1 : 0)
        /// Ignore seconds
        currentComponents.second = 0
        /// Construct the new alarm fire date
        guard let fireDate = calendar.date(from: currentComponents) else {
            return nil
        }
        
        /// Finally, check to see if the new alarm date is in the past. If it is, add another day.
        /// This makes sure that alarms with times prior to the current time can fire in the future.
        if fireDate <= Date() {
            let futureDate = calendar.date(byAdding: .day, value: 1, to: fireDate)
            return futureDate
        } else {
            return fireDate
        }
        
    }
    
}

//
//  AlarmProtocol.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

/// Protocol to cover both local and remote alarms.
protocol Alarm {
    
    var id: UUID { get }
    var timestamp: String { get }
    var recurring: Bool { get }
    var alarmSound: SoundType { get }
    var isRemote: Bool { get }
    
}

/// Extension to the Alarm protocol that adds shared computed properties.
extension Alarm {
    
    /// The fireDate is added to the timers in the AlarmListView view model.
    var fireDate: Date? {
        self.timestamp.toDate()
    }
    
    /// The sort string is needed to help sort the alarm list in ascending order.
    var sortString: String {
        guard let date = fireDate else {
            return ""
        }
        return date.toSortString()
    }
    
    /// The display string is used to show the alarm time in the main list.
    var displayString: String {
        guard let date = fireDate else {
            return ""
        }
        return date.toDisplayString()
    }
    
}

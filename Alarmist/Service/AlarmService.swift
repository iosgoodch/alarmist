//
//  AlarmService.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

struct AlarmService: WebServiceProtocol {
    
    /// Enum of endpoints for the Alarm service.
    /// Currently only the fetch endpoint exists. This can be expanded.
    enum Endpoint: String {
        case fetchAlarmList = "99a3e77e-4848-4ed6-9ecd-f1918babac1b"
    }
    
}

//
//  WebServiceProtocol.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

/// Protocol definition for all endpoint services
protocol WebServiceProtocol {
    /// The associatedtype hole to be filled by the endpoint service
    associatedtype Endpoint: RawRepresentable where Endpoint.RawValue == String
}

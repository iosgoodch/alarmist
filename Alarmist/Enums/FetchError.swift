//
//  FetchError.swift
//  Alarmist
//
//  Created by John Goodchild on 10/10/24.
//

import Foundation

enum FetchError: Error {
    /// Throw when a URL cannot be loaded
    case badUrl
    
    /// Throw when data cannot be fetched from the backend
    case serverError
    
    /// Throw when the response contains no data
    case missingDataResponse

    /// Throw in all other cases
    case unexpected(code: Int)
}

extension FetchError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .badUrl:
            return "Bad URL."
        case .serverError:
            return "Unable to fetch data from the backend."
        case .missingDataResponse:
            return "The alarm details cannot be loaded."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
    
}

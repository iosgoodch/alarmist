//
//  DataLoader.swift
//  Alarmist
//
//  Created by John Goodchild on 10/10/24.
//

import Foundation

class DataLoader {
    
    static let shared = DataLoader()
    
    func fetchAlarmList() async throws -> RemoteAlarms {
        let endpoint = AlarmService.Endpoint.fetchAlarmList.rawValue
        guard let url = BaseService().url(route: endpoint) else {
            /// The URL is nil.
            throw FetchError.badUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            /// The backend response was bad.
            throw FetchError.serverError
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            /// Return the decoded data.
            return try decoder.decode(RemoteAlarms.self, from: data)
        } catch {
            /// The response data is empty.
            throw FetchError.missingDataResponse
        }
    }
    
}

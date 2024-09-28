//
//  BaseService.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import Foundation

struct BaseService {
    
    /*
     The base service allows for expansion of the web protocol, domain,
     and route based on the app environment. For the purposes of this app,
     we do not need such refinement, but it can be expanded as needed.
     */
    
    let webProtocol = "https://"
    let domain = "mocki.io"
    let baseRoute = "/v1/"
    
    func url(route: String, replacements: [String: String] = [:]) -> URL? {
        var theUrl = webProtocol + domain
        theUrl.append(contentsOf: baseRoute + route)
        
        /// If the route URL contains replacable path arguments, they are handled here.
        for (key, value) in replacements {
            theUrl = theUrl.replacingOccurrences(of: "{\(key)}", with: value)
        }
        
        return URL(string: theUrl)
    }
    
}

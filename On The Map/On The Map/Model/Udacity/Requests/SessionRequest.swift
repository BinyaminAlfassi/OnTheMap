//
//  SessionRequest.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 16/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation

struct SessionRequest: Codable{
    var udacity: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}

enum Credentials: String {
    case username = "username"
    case password = "password"
}

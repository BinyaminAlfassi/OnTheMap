//
//  SessionResponse.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 16/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation


struct SessionResponse: Codable {
    var account: SessionResponseAccount
    var session: SessionResponseSession
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}

struct SessionResponseAccount: Codable {
    var registered: Bool
        var key: String
        
        enum CodingKeys: String, CodingKey {
            case registered
            case key
        }
}

struct SessionResponseSession: Codable {
    var id: String
    var expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
}

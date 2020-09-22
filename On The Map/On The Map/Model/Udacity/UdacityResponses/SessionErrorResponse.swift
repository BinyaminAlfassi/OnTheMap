//
//  SessionErrorResponse.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 17/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation

struct SessionErrorResponse: Codable {
    var status: Int
    var error: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case error
    }
}

extension SessionErrorResponse: LocalizedError {
    var errorDescription: String? {return error}
}

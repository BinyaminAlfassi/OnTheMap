//
//  StudentLocationPostResponse.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 20/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation

struct StudentLocationPostResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}

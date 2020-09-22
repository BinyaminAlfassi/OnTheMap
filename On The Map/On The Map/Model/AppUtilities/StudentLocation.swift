//
//  student.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 19/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}

struct StudentLocationBody: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
    }
}

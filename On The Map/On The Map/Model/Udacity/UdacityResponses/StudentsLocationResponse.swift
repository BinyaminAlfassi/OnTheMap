//
//  StudentsLocationResponse.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 16/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation


struct StudentsLocationResponse: Codable {
    var results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

//
//  ServiceResponse.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 09/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import Foundation

struct ServiceResponse: Codable {
    let results: [Game]
    let next: String?
    let previous: String?
}



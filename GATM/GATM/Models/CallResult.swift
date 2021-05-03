//
//  CallResult.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 09/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import Foundation

struct GamesResult {
    let games: [Game]?
    let error: Error?
    let currentPage: Int
    let nextPageUrlString: String?
    var hasMorePages: Bool {
        return nextPageUrlString != nil
    }
}

struct DescriptionResult {
    let description: Description?
    let error: Error?
}

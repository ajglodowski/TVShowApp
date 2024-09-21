//
//  ShowStatusCountDto.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/24/24.
//

import Foundation
struct ShowStatusCountDto: Codable {
    var showId: Int
    var status: Int
    var count: Int
}

let ShowStatusCountDtoProperties = "showId, status, count"

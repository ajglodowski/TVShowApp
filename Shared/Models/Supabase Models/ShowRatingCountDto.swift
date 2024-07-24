//
//  ShowRatingCountDto.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/12/24.
//

import Foundation

struct ShowRatingCountDto: Codable {
    var showId: Int
    var rating: Rating
    var count: Int
}

let ShowRatingCountDtoProperties = "showId, rating, count"

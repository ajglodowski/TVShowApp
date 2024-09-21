//
//  ShowFilters.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import Foundation
struct ShowFilters {
    var service: [SupabaseService]
    var length: [ShowLength]
    var airDate: [AirDate?]
    var limitedSeries: Bool?
    var running: Bool?
    var currentlyAiring: Bool?
}

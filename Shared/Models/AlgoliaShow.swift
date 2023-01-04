//
//  AlgoliaShow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/3/23.
//

import Foundation
import SwiftUI
import Combine

struct AlgoliaShow : Codable {
    
    // Both
    var name: String // Needed for Actors
    var service: Service // Needed for Actors
    var running: Bool
    var tags: [Tag]?
    var totalSeasons: Int
    var limitedSeries: Bool
    var length: ShowLength
    var releaseDate: Date?
    var airdate: AirDate?
    
    //var currentlyAiring: Bool

}

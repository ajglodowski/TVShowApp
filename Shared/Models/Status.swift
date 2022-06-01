//
//  Status.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/17/21.
//

import Foundation

enum Status: String, CaseIterable, Codable, Identifiable {
    case UpToDate = "Up to Date"
    case NeedsWatched = "Needs Watched"
    case SeenEnough = "Seen Enough"
    case ShowEnded = "Show Ended"
    case CurrentlyAiring = "Currently Airing"
    case NewRelease = "New Release"
    case NewSeason = "New Season"
    case CatchingUp = "Catching Up"
    case ComingSoon = "Coming Soon"
    
    case Other
    
    var id: String { self.rawValue }
}



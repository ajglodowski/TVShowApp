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
    case CurrentlyWatching = "Currently Watching" // Outdated, need to update data with these values
    case NewSeason = "New Season"
    case CatchingUp = "Catching Up"
    
    case Other
    
    var id: String { self.rawValue }
}



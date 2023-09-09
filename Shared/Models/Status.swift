//
//  Status.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/17/21.
//

import Foundation

enum Status: String, CaseIterable, Codable, Identifiable, Hashable {
    case UpToDate = "Up to Date"
    case NeedsWatched = "Needs Watched"
    case SeenEnough = "Seen Enough"
    case ShowEnded = "Show Ended"
    case CurrentlyAiring = "Currently Airing"
    case NewRelease = "New Release"
    case NewSeason = "New Season"
    case CatchingUp = "Catching Up"
    case ComingSoon = "Coming Soon"
    case Rewatching = "Rewatching"
    
    case Other
    
    var order: Int {
        switch(self) {
        case Status.CurrentlyAiring:
            return 0
        case Status.CatchingUp:
            return 1
        case Status.NewRelease:
            return 2
        case Status.NewSeason:
            return 3
        case Status.Rewatching:
            return 4
        case Status.ComingSoon:
            return 5
        case Status.NeedsWatched:
            return 6
        case Status.UpToDate:
            return 7
        case Status.ShowEnded:
            return 8
        case Status.SeenEnough:
            return 9
        case Status.Other:
            return 10
        default:
            return -1
        }
    }
    
    var id: String { self.rawValue }
}



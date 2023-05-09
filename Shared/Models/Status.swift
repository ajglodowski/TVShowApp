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
        case Status.ComingSoon:
            return 4
        case Status.NeedsWatched:
            return 5
        case Status.UpToDate:
            return 6
        case Status.ShowEnded:
            return 7
        case Status.SeenEnough:
            return 8
        case Status.Other:
            return 9
        default:
            return -1
        }
    }
    
    var id: String { self.rawValue }
}



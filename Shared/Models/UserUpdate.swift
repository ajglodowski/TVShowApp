//
//  UserUpdate.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/1/23.
//

import Foundation
import SwiftUI
import Combine

struct UserUpdate : Hashable, Identifiable, Codable {
    // Required
    var id: String
    var userId: String
    var showId: String
    var updateType: UserUpdateCategory
    var updateDate: Date
    // Type-Dependent
    var statusChange: Status?
    var seasonChange: Int?
    
    var updateMessage: String {
        switch self.updateType {
            case UserUpdateCategory.ChangedSeason:
                return "Updated current season to \(self.seasonChange!)"
            case UserUpdateCategory.AddedToWatchlist:
                return "Added show to your Watchlist"
            case UserUpdateCategory.UpdatedStatus:
                return "Updated status to \(self.statusChange!.rawValue)"
            case UserUpdateCategory.RemovedFromWatchlist:
                return "Removed from your watchlist"
            default:
                return "Update Type Error"
        }
    }
    
}

enum UserUpdateCategory: String, CaseIterable, Codable, Identifiable {
    case AddedToWatchlist
    case UpdatedStatus
    case RemovedFromWatchlist
    case ChangedSeason
    
    var id: String { self.rawValue }
}

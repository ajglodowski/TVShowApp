//
//  UserUpdate.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/1/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

struct UserUpdate : Hashable, Identifiable, Codable {
    // Required
    var id: Int
    var userId: String
    var showId: Int
    var updateType: UserUpdateCategory
    var updateDate: Date
    // Type-Dependent
    var statusChange: Status?
    var seasonChange: Int?
    var ratingChange: Rating?
    
    var updateMessage: String {
        switch self.updateType {
            case UserUpdateCategory.ChangedSeason:
                return "Updated current season to \(self.seasonChange!)"
            case UserUpdateCategory.AddedToWatchlist:
                return "Added to Watchlist"
            case UserUpdateCategory.UpdatedStatus:
                return "Updated status to \(self.statusChange!.name)"
            case UserUpdateCategory.RemovedFromWatchlist:
                return "Removed from your watchlist"
            case UserUpdateCategory.ChangedRating:
                return "Rated \(self.ratingChange!.rawValue)"
            case UserUpdateCategory.RemovedRating:
                return "Removed rating"
            default:
                return "Update Type Error"
        }
    }
    
    init(from: SupabaseUserUpdate) {
        self.id = from.id
        self.userId = from.userId
        self.showId = from.showId
        self.updateType = from.updateType
        self.updateDate = from.updateDate
        self.statusChange = from.statusChange
        self.seasonChange = from.seasonChange
        self.ratingChange = from.ratingChange
    }
    
}

enum UserUpdateCategory: String, CaseIterable, Codable, Identifiable {
    case AddedToWatchlist
    case UpdatedStatus
    case RemovedFromWatchlist
    case ChangedSeason
    case ChangedRating
    case RemovedRating
    
    case Other
    
    var id: String { self.rawValue }
}

/*
func convertUpdateToDict(update: UserUpdate) -> [String:Any] {
    var out = [String:Any]()
    out["showId"] = update.showId
    out["userId"] = update.userId
    out["updateType"] = update.updateType.rawValue
    out["updateDate"] = update.updateDate
    if (update.seasonChange != nil) { out["seasonChange"] = update.seasonChange! }
    if (update.statusChange != nil) { out["statusChange"] = update.statusChange!.rawValue }
    if (update.ratingChange != nil) { out["ratingChange"] = update.ratingChange!.rawValue }
    return out
}

func convertDataDictToUserUpdate(updateId: String, data: [String:Any]) -> UserUpdate {
    let showId = data["showId"] as! String
    let userId = data["userId"] as! String
    let updateDate = data["updateDate"] as! Timestamp
    let updateType = data["updateType"] as! String
    
    let seasonChange = data["seasonChange"] as? Int // Type specific values
    let statusChangeRaw = data["statusChange"] as? String
    let ratingChangeRaw = data["ratingChange"] as? String
    let statusChange = (statusChangeRaw != nil) ? Status(rawValue: statusChangeRaw!) : nil
    let ratingChange = (ratingChangeRaw != nil) ? Rating(rawValue: ratingChangeRaw!) : nil
    
    let update = UserUpdate(id: updateId, userId: userId, showId: showId, updateType: UserUpdateCategory(rawValue: updateType)!, updateDate: updateDate.dateValue(), statusChange: statusChange, seasonChange: seasonChange, ratingChange: ratingChange)
    return update
}
*/

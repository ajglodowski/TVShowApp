//
//  ShowUserSpecificDetails.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/8/23.
//

import Foundation
import Firebase
//import SwiftData

// Stored in Firestore at {userID}/shows where the documentId is the show's id.
// The"PK" is a combination of userId and showId, no specific details id.

//@Model
struct ShowUserSpecificDetails: Hashable {
    
    static func == (lhs: ShowUserSpecificDetails, rhs: ShowUserSpecificDetails) -> Bool {
        return lhs.userId == rhs.userId && lhs.showId == rhs.showId && lhs.updated == rhs.updated
    }
    
    
    var userId: String
    var showId: String
    var status: Status
    var updated: Date // Date these details were last updated

    var currentSeason: Int
    var rating: Rating?
    
    var currentUserUpdates: [UserUpdate]?
    var lastUpdateDate: Date? {
        currentUserUpdates?.max { $0.updateDate < $1.updateDate }?.updateDate
    }
    
    
    init (userId: String, showId: String, status: Status,
          updated: Date, currentSeason: Int, rating: Rating? = nil, currentUserUpdates: [UserUpdate]? = nil) {
        self.userId = userId
        self.showId = showId
        self.status = status
        self.updated = updated
        self.currentSeason = currentSeason
        self.rating = rating
        self.currentUserUpdates = currentUserUpdates
    }
    
}

var SampleUserDetails: ShowUserSpecificDetails {
    return ShowUserSpecificDetails(userId: "123", showId: "456", status: Status.NeedsWatched, updated: Date(), currentSeason: 2, rating: Rating.Meh, currentUserUpdates: nil)
}

func convertUserSpecificDetailsToDictionary(details: ShowUserSpecificDetails) -> [String:Any] {
    var output = [String:Any]()
    
    output["status"] = details.status.rawValue
    output["updated"] = details.updated
    output["currentSeason"] = details.currentSeason
    output["rating"] = details.rating?.rawValue ?? nil
    
    return output
}

func convertUserSpecificDetailsDictToObj(data: [String:Any]) -> ShowUserSpecificDetails {

    // Not fields
    let userId = data["userId"] as! String
    let showId = data["showId"] as! String
    //Fields
    let status = data["status"] as! String
    let updated = data["updated"] as! Timestamp
    let currentSeason = data["currentSeason"] as! Int
    let rating = data["rating"] as? String
    
    var ratingObj: Rating? = nil
    if (rating != nil) { ratingObj = Rating(rawValue: rating!) ?? nil }
    
    let out = ShowUserSpecificDetails(userId: userId,
                                      showId: showId, status: Status(rawValue: status) ?? Status.Other,
                                      updated: updated.dateValue(), currentSeason: currentSeason, rating: ratingObj)
    
    return out
}

/*
@MainActor func loadUserSpecificDetailsFromData(context: ModelContext, showId: String, userId: String) -> ShowUserSpecificDetails? {
    let details = FetchDescriptor<ShowUserSpecificDetails>(
        predicate: #Predicate { $0.showId == showId && $0.userId == userId }
    )
    let results = try! context.fetch(details)
    return results.first
}

@MainActor func saveUserSpecificDetailsToData(context: ModelContext, detailsObj: ShowUserSpecificDetails)  {
    let previousCopy = loadUserSpecificDetailsFromData(context: context, showId: detailsObj.showId, userId: detailsObj.userId)
    if (previousCopy != nil && detailsObj.updated <= previousCopy!.updated) { return } // Minor error checking
    context.insert(detailsObj)
    try! context.save()
    print("Saved something")
}

@MainActor func syncUserSpecificDetailsToData(context: ModelContext, data: [ShowUserSpecificDetails]) {
    print("Starting sync")
    for show in data {
        saveUserSpecificDetailsToData(context: context, detailsObj: show)
    }
}
*/

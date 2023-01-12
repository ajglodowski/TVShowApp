//
//  UserUpdateFunctions.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/1/23.
//

import Foundation
import Firebase

func addUserUpdateWatchlist(userId: String, show: Show) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.AddedToWatchlist, updateDate: Date())
    _ = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateRemove(userId: String, show: Show) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.RemovedFromWatchlist, updateDate: Date())
    _ = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateStatusChange(userId: String, show: Show) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.UpdatedStatus, updateDate: Date(), statusChange: show.status)
    _ = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateSeasonChange(userId: String, showId: String, seasonUpdate: Int) {
    let update = UserUpdate(id: "1", userId: userId, showId: showId, updateType: UserUpdateCategory.ChangedSeason, updateDate: Date(), seasonChange: seasonUpdate)
    _ = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateRatingChange(userId: String, show: Show, rating: Rating) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.ChangedRating, updateDate: Date(), ratingChange: rating)
    _ = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateRatingRemoval(userId: String, show: Show) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.RemovedRating, updateDate: Date())
    _ = pushUserUpdateToFireStore(update: update)
}

func pushUserUpdateToFireStore(update: UserUpdate) -> String {
    let updateData = convertUpdateToDict(update: update)
    let docRef = Firestore.firestore().collection("updates").document()
    docRef.setData(updateData)
    return docRef.documentID
}

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

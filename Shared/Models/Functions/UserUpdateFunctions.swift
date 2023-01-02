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
    let updateId = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateRemove(userId: String, show: Show) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.RemovedFromWatchlist, updateDate: Date())
    let updateId = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateStatusChange(userId: String, show: Show) {
    let update = UserUpdate(id: "1", userId: userId, showId: show.id, updateType: UserUpdateCategory.UpdatedStatus, updateDate: Date(), statusChange: show.status)
    let updateId = pushUserUpdateToFireStore(update: update)
}

func addUserUpdateSeasonChange(userId: String, showId: String, seasonUpdate: Int) {
    let update = UserUpdate(id: "1", userId: userId, showId: showId, updateType: UserUpdateCategory.ChangedSeason, updateDate: Date(), seasonChange: seasonUpdate)
    let updateId = pushUserUpdateToFireStore(update: update)
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
    return out
}

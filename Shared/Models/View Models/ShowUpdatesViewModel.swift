//
//  ShowUpdatesViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/12/23.
//

import Foundation

import Foundation
import Swift
import SwiftUI
import Firebase

class ShowUpdatesViewModel: ObservableObject {
    
    private var fireStore = Firebase.Firestore.firestore()
    
    private let currentUser = Auth.auth().currentUser?.uid
    
    func loadUpdates(modelData: ModelData, showId: String, friends: [String]) {
        self.loadUserUpdates(modelData: modelData,showId: showId)
        self.loadFriendUpdates(modelData: modelData, showId: showId, friends: friends)
    }
    
    private func loadUserUpdates(modelData: ModelData, showId: String) {
        if (self.currentUser == nil) { print("User null"); return }
        let updates = fireStore.collection("updates").whereField("showId", isEqualTo: showId).whereField("userId", isEqualTo: self.currentUser!)
        updates.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let updateId = document.documentID
                    let data = document.data()
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
                    modelData.updateDict[updateId] = update
                }
            }
        }
    }
    
    
    private func loadFriendUpdates(modelData: ModelData, showId: String, friends: [String]) {
        if (self.currentUser == nil || friends.isEmpty) { return }
        let updates = fireStore.collection("updates").whereField("showId", isEqualTo: showId).whereField("userId", in: friends)
        updates.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let updateId = document.documentID
                    let data = document.data()
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
                    modelData.updateDict[updateId] = update
                }
            }
        }
    }
        
    
}

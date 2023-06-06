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
                var updates = [UserUpdate]()
                for document in snapshot.documents {
                    let updateId = document.documentID
                    let data = document.data()
                    let update = convertDataDictToUserUpdate(updateId: updateId, data: data)
                    modelData.updateDict[updateId] = update
                    updates.append(update)
                }
                if (modelData.showDict[showId] != nil && modelData.showDict[showId]!.addedToUserShows) { modelData.showDict[showId]!.userSpecificValues!.currentUserUpdates = updates }
                
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
                    let update = convertDataDictToUserUpdate(updateId: updateId, data: data)
                    modelData.updateDict[updateId] = update
                }
            }
        }
    }
    
    
    // Loads the 20 most recent updates of the given user into the app's memory
    public func loadMostRecent20Updates(modelData: ModelData, userId: String) {
        let dbDoc = fireStore.collection("updates").whereField("userId", isEqualTo: userId).order(by: "updateDate", descending: true).limit(to: 20)
        dbDoc.getDocuments { querySnapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            for document in querySnapshot!.documents {
                let data = document.data()
                let updateId = document.documentID
                let update = convertDataDictToUserUpdate(updateId: updateId, data: data)
                let showId = update.showId
                if (modelData.showDict[showId]!.userSpecificValues!.currentUserUpdates != nil) { modelData.showDict[showId]!.userSpecificValues!.currentUserUpdates!.append(update) }
                else { modelData.showDict[showId]!.userSpecificValues!.currentUserUpdates = [update] }
                
                modelData.updateDict[updateId] = update
            }
        }
        
    }
        
    
}

//
//  ShowListViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase

class ShowListViewModel: ObservableObject {
    
    @Published var showListObj: ShowList? = nil
    
    var loadedShows = [String:Show]()
    
    //private var ref: DatabaseReference = Database.database().reference()
    private var fireStore = Firebase.Firestore.firestore()
    
    @MainActor
    func loadList(id: String, showLimit: Int? = nil) async {
        //fireStore.clearPersistence()
        let show = fireStore.collection("lists").document("\(id)")
        let snapshot = try! await show.getDocument()
        let optData = snapshot.data()
        if (optData == nil) { return }
        let data = optData!
        
        let name = data["name"] as! String
        let description = data["description"] as! String
        let ordered = data["ordered"] as! Bool
        let priv = data["priv"] as! Bool
        let likeCount = data["likeCount"] as! Int
        
        // Loading profile
        let profId = data["profileId"] as! String
        let profile = await loadProfile(id: profId)
        
        // Loading shows
        var showIds = data["shows"] as! [String]
        if (showLimit != nil) {
            showIds = showIds.prefix(showLimit!).map{String($0)}
        }
        // TODO Handle show loading to use memory better
        var shows = [Show]()
        let showsCol = fireStore.collection("shows")
        for showId in showIds {
            if (loadedShows[showId] != nil) { shows.append(loadedShows[showId]!) }
            else {
                let snapshot = try! await showsCol.document(showId).getDocument()
                let data = snapshot.data()!
                var add = convertShowDictToShow(showId: showId, data: data)
                shows.append(add)
            }
        }
        let add = ShowList(id: id, name: name, description: description, shows: shows, ordered: ordered, priv: priv, profile: profile, likeCount: likeCount)
        self.showListObj = add
    }
    
    func loadProfile(id: String) async -> Profile {
        
        let profId = id
        let profDoc = fireStore.collection("users").document("\(profId)")
        let snapshot = try! await profDoc.getDocument()
        let optData = snapshot.data()
        if (optData == nil) { print("Error Loading user for a list") }
        let data = optData!
        let add = convertProfileDictToProfile(profileId: id, data: data)
        return add
        
    }
}

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
    
    //private var ref: DatabaseReference = Database.database().reference()
    private var fireStore = Firebase.Firestore.firestore()
    
    @MainActor
    func loadList(id: String) async {
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
        let showIds = data["shows"] as! [String]
        var shows = [Show]()
        let showsCol = fireStore.collection("shows")
        for showId in showIds {
            let snapshot = try! await showsCol.document(showId).getDocument()
               
            let data = snapshot.data()!
            var add = Show(id: showId)
            let name = data["name"] as! String
            let running = data["running"] as! Bool
            let totalSeasons = data["totalSeasons"] as! Int
            let tags = data["tags"] as? [String] ?? [String]()
            let currentlyAiring = data["currentlyAiring"] as? Bool ?? false
            let service = data["service"] as! String
            let limitedSeries = data["limitedSeries"] as! Bool
            let length = data["length"] as! String
            let releaseDate = data["releaseDate"] as? Timestamp
            let airdate = data["airdate"] as? String
            let actors = data["actors"] as? [String: String]
            let ratingCounts = data["ratingCounts"] as! [String: Int]
            var tagArray = [Tag]()
            for tag in tags {
                tagArray.append(Tag(rawValue: tag)!)
            }
            add.name = name
            add.running = running
            add.totalSeasons = totalSeasons
            add.tags = tagArray
            add.currentlyAiring = currentlyAiring
            add.service = Service(rawValue: service)!
            add.limitedSeries = limitedSeries
            add.length = ShowLength(rawValue: length)!
            if (airdate != nil) { add.airdate = AirDate(rawValue: airdate!) }
            add.releaseDate = releaseDate?.dateValue()
            if (actors != nil) { add.actors = actors }
            for (key, value) in ratingCounts {
                add.ratingCounts[Rating(rawValue: key)!] = value
            }
            shows.append(add)
        }
        let add = ShowList(id: id, name: name, description: description, shows: shows, ordered: ordered, priv: priv, profile: profile, likeCount: likeCount)
        self.showListObj = add
    }
    
    func loadProfile(id: String) async -> Profile {
        
        let profId = id
        let profDoc = fireStore.collection("users").document("\(profId)")
        let snapshot = try! await profDoc.getDocument()
        let optData = snapshot.data()
        let data = optData!
        
        let username = data["username"] as! String
        var profilePhotoURL = data["profilePhotoURL"] as? String
        let bio = data["bio"] as? String
        let showCount = data["showCount"] as! Int
        
        let followingCount = data["followingCount"] as! Int
        let followerCount = data["followerCount"] as! Int
        let followers = data["followers"] as? [String:String]
        let following = data["following"] as? [String:String]
        let showLists = data["showLists"] as? [String]
        let likedShowLists = data["likedShowLists"] as? [String]
        
        let pinnedShows =  data["pinnedShows"] as? [String:String]
        let pinnedShowCount = data["pinnedShowCount"] as? Int ?? 0
        let add = Profile(id: id, username: username, profilePhotoURL: profilePhotoURL, bio: bio, pinnedShows: pinnedShows, pinnedShowCount: pinnedShowCount, showCount: showCount, followingCount: followingCount, followerCount: followerCount, followers: followers, following: following, showLists: showLists, likedShowLists: likedShowLists)
        return add
        
    }
}

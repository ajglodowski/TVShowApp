//
//  Profile.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import SwiftUI
import Combine

struct Profile : Hashable, Identifiable, Codable {
    
    var id: String
    var username: String
    var profilePhotoURL: String?
    var bio: String?
    var pinnedShows: [String:String]?
    var pinnedShowCount: Int
    var showCount: Int
    var followingCount: Int
    var followerCount: Int
    var followers: [String:String]? // ID: Username
    var following: [String:String]?
    var showLists: [String]? // Array of ids
    var likedShowLists: [String]? // Array of ids
    //var shows: [String: String]
    
    //let id : String = UUID().uuidString
    /*
    init(id: String) {
        self.id = id
        self.username = "New Profile"
        self.profilePhotoURL = username
        //self.shows = [String:String]()
        //self.shows = [Show]()
    }
     */

}

func convertProfileDictToProfile(profileId: String, data: [String:Any]) -> Profile {
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
    let add = Profile(id: profileId, username: username, profilePhotoURL: profilePhotoURL, bio: bio, pinnedShows: pinnedShows, pinnedShowCount: pinnedShowCount, showCount: showCount, followingCount: followingCount, followerCount: followerCount, followers: followers, following: following, showLists: showLists, likedShowLists: likedShowLists)
    return add
}

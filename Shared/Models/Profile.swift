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
    var created_at: Date
    var profilePhotoURL: String?
    var bio: String?
    var pinnedShows: [String:String]?
    var pinnedShowCount: Int?
    var showCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    var followers: [String:String]? // ID: Username
    var following: [String:String]?
    var showLists: [Int]? // Array of ids
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
    init(from: SupabaseProfile) {
        self.id = from.id
        self.username = from.username
        self.profilePhotoURL = from.profilePhotoURL
        self.created_at = from.created_at
    }
    
    init(id: String, username: String, created_at: Date, profilePhotoURL: String?) {
        self.id = id
        self.username = username
        self.created_at = created_at
        self.profilePhotoURL = profilePhotoURL
    }

}

var MockProfile = Profile(id: "c52a052a-4944-4257-ad77-34f2f002104c", username: "ajglodo", created_at: Date(), profilePhotoURL: "ajglodo")


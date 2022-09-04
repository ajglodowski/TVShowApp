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
    var profilePhotoURL: String
    var bio: String
    var lovedShows: [Show]
    var showCount: Int
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

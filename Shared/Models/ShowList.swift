//
//  List.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import Foundation
import SwiftUI
import Combine

struct ShowList : Hashable, Identifiable, Codable {
    
    var id: String
    var name: String
    var description: String
    var shows: [Show]
    var ordered: Bool
    var priv: Bool
    var profile: Profile
    
    //let id : String = UUID().uuidString
    /*
    init(id: String) {
        self.id = id
        self.name = "New List"
        self.description = ""
        self.shows = [Show]()
        self.ordered = false
        self.priv = false
        self.profile = Profile(id: "1", username: "TempUser", pinnedShowCount: 0, showCount: 0, followingCount: 0, followerCount: 0)
    }
     */

}

//
//  List.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import Foundation
import SwiftUI
import Combine

struct ShowList : Hashable, Identifiable {
    
    var id: String
    var name: String
    var description: String
    var shows: [Show]
    var ordered: Bool
    var priv: Bool
    var profile: Profile
    var likeCount: Int
    
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

func convertListToDict(list: ShowList) -> [String:Any] {
    var out = [String:Any]()
    out["name"] = list.name
    out["description"] = list.description
    out["likeCount"] = list.likeCount
    out["priv"] = list.priv
    out["ordered"] = list.ordered
    out["shows"] = list.shows.map { $0.id }
    out["profileId"] = list.profile.id
    return out
}

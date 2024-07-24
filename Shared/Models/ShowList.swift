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
    
    var id: Int
    var name: String
    var description: String
    var shows: [ShowListEntry]
    var ordered: Bool
    var priv: Bool
    var creator: String
    // var likeCount: Int // TODO Later
    
    
    init(list: SupabaseShowList, entries: [SupabaseShowListEntry]) {
        self.id = list.id
        self.name = list.name
        self.description = list.description
        let mapped = entries.map { ShowListEntry(from: $0) }
        self.shows = mapped
        self.ordered = list.ordered
        self.priv = list.private
        self.creator = list.creator
    }
     

}

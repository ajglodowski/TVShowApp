//
//  ShowListEntry.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/23/24.
//

import Foundation
struct ShowListEntry : Hashable, Identifiable {
    var id: Int
    var created_at: Date
    var listId: Int
    var show: Show
    var position: Int
    
    init(from: SupabaseShowListEntry) {
        self.id = from.id
        self.created_at = from.created_at
        self.listId = from.listId
        self.show = Show(from: from.show)
        self.position = from.position
    }
    
}

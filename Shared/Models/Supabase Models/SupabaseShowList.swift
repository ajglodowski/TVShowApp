//
//  SupabaseShowList.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/23/24.
//

import Foundation

struct SupabaseShowList : Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var ordered: Bool
    var `private`: Bool
    var creator: String
    var created_at: Date
    var updated_at: Date?
    
    init(from: ShowList) {
        self.id = from.id
        self.name = from.name
        self.description = from.description
        self.ordered = from.ordered
        self.private = from.priv
        self.creator = from.creator
        self.created_at = Date()
        self.updated_at = Date()
    }

    init(creator: String) {
        self.id = -1
        self.name = "New List"
        self.description = ""
        self.ordered = true
        self.private = false
        self.creator = creator
        self.created_at = Date()
        self.updated_at = nil
    }
    
}

let SupabaseShowListProperties = "id, name, description, ordered, private, creator, created_at, updated_at"
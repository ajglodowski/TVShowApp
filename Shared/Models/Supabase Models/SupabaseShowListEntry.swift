//
//  SupabaseShowListEntry.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/23/24.
//

import Foundation

struct SupabaseShowListEntry : Hashable, Codable, Identifiable {
    var id: Int
    var created_at: Date
    var listId: Int
    var show: SupabaseShow
    var position: Int
}

let SupabaseShowListEntryProperties = "id, created_at, listId, showId, position"

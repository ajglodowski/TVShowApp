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

struct SupabaseShowListEntryInsertDto : Hashable, Codable {
    var created_at: Date
    var listId: Int
    var showId: Int
    var position: Int
}


let SupabaseShowListEntryProperties = "id, created_at, listId, show (\(SupabaseShowProperties)), position"

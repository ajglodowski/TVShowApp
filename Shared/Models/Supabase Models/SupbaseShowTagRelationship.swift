//
//  SupbaseShowTagRelationship.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/26/24.
//

import Foundation

import Foundation
struct SupabaseShowTagRelationship: Codable {
    var showTagId: Int? // Nullable for inserts
    var showId: Int
    var tagId: Int
    var showName: String?
    var tagName: String?
}

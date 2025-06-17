//
//  SupabaseService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/23/24.
//

import Foundation

struct SupabaseService : Hashable, Codable, Identifiable {
    var id : Int
    var createdAt: Date
    var name: String
    var color: String?
}

var SupabaseServiceProperties = "id, createdAt, name, color"
var MockSupabaseService = SupabaseService(id: 14, createdAt: Date(), name: "Other", color: nil)

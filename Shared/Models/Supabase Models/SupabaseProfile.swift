//
//  SupabaseProfile.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/27/24.
//

import Foundation
struct SupabaseProfile: Hashable, Codable, Identifiable {
    var id : String
    var username: String
    var created_at: Date
    var profilePhotoURL: String?
}

var SupabaseProfileProperties = "id, username, created_at, profilePhotoURL"
var MockSupabaseProfile = SupabaseProfile(id: "c52a052a-4944-4257-ad77-34f2f002104c", username: "ajglodo", created_at: Date(), profilePhotoURL: "ajglodo.jpg")

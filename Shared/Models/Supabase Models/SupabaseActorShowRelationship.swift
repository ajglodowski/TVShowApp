//
//  SupabaseActorShowRelationship.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 12/15/23.
//

import Foundation
struct SupabaseActorShowRelationship: Codable {
    var showId: Int
    var actor: Actor
}

let SupabaseActorShowRelationshipProperties = "showId, actor!inner(\(ActorProperties))"

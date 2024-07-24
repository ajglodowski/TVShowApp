//
//  SupabaseActor.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 12/15/23.
//

import Foundation
struct SupabaseActor : Hashable, Identifiable, Codable {
    var id: String? // Optional for inserts
    var name: String
}

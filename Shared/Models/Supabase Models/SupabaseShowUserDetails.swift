//
//  SupabaseShowUserDetails.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 12/15/23.
//

import Foundation

struct SupabaseShowUserDetails: Hashable, Codable, Identifiable {
    
    var id: String  { "\(userId),\(showId)" }
    var userId: String
    var showId: Int
    var status: Status
    var updated: Date // Date these details were last updated
    var created_at: Date // Date these details were first created

    var currentSeason: Int
    var rating: Rating?
    var firebaseShowId: String?
    
    private enum CodingKeys : String, CodingKey { case userId, showId, status, updated, created_at, currentSeason, rating, firebaseShowId }
    
}

var SupabaseShowUserDetailsProperties = "userId, showId, status (id, name, created_at, update_at), updated, created_at, currentSeason, rating, firebaseShowId"

var MockSupabaseShowUserDetails = SupabaseShowUserDetails(userId: MockProfile.id, showId: 1, status: MockStatus, updated: Date(), created_at: Date(), currentSeason: 1)

func convertToSupabaseShowUserDetails(show: ShowUserSpecificDetails) -> SupabaseShowUserDetails {
    return SupabaseShowUserDetails(userId: show.userId, showId: 1, status: MockStatus, updated: show.updated, created_at: show.updated, currentSeason: show.currentSeason, rating: show.rating, firebaseShowId: nil)
}

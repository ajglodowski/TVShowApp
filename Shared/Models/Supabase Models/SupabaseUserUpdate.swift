//
//  SupabaseUserUpdate.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/27/24.
//

import Foundation
struct SupabaseUserUpdate : Hashable, Codable, Identifiable {
    var id : Int
    var updateDate: Date
    var userId: String
    var showId: Int
    var statusChange: Status?
    var seasonChange: Int?
    var ratingChange: Rating?
    var updateType: UserUpdateCategory
    var firebaseShowId: String?
}

struct SupabaseUserUpdateInsert:Codable {
    var updateDate: Date
    var userId: String
    var showId: Int
    var statusChange: Int?
    var seasonChange: Int?
    var ratingChange: Rating?
    var updateType: UserUpdateCategory
    var firebaseShowId: String?
    
    init(from: SupabaseUserUpdate) {
        self.updateDate = from.updateDate
        self.userId = from.userId
        self.showId = from.showId
        self.statusChange = from.statusChange?.id ?? nil
        self.seasonChange = from.seasonChange
        self.ratingChange = from.ratingChange
        self.updateType = from.updateType
        self.firebaseShowId = from.firebaseShowId
    }
    
}

var SupabasUserUpdateProperties = "id, updateDate, userId, showId, statusChange (id, name, created_at, update_at), seasonChange, ratingChange, updateType, firebaseShowId"
var MockSupabasUserUpdate = SupabaseUserUpdate(id: 1, updateDate: Date(), userId: MockSupabaseProfile.id, showId: 100, updateType: UserUpdateCategory.Other)

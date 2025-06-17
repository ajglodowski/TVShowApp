//
//  SupabaseShow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 12/15/23.
//

import Foundation

struct SupabaseShow : Hashable, Codable, Identifiable {
    
    var id : Int
    var created_at: Date
    var lastUpdated: Date // Date the show was last updated
    var name: String
    var service: SupabaseService
    var running: Bool
    var limitedSeries: Bool
    var totalSeasons: Int
    var releaseDate: String?
    var airdate: AirDate?
    var currentlyAiring: Bool
    var length: ShowLength
    var firebaseShowId: String?
    var pictureUrl: String?
    
    init(id: Int, created_at: Date, lastUpdated: Date, name: String, service: SupabaseService, running: Bool, limitedSeries: Bool, totalSeasons: Int, releaseDate: String?, airdate: AirDate?, currentlyAiring: Bool, length: ShowLength, firebaseShowId: String?, pictureUrl: String?) {
        self.id = id
        self.created_at = created_at
        self.lastUpdated = lastUpdated
        self.name = name
        self.service = service
        self.running = running
        self.limitedSeries = limitedSeries
        self.totalSeasons = totalSeasons
        self.releaseDate = releaseDate
        self.airdate = airdate
        self.currentlyAiring = currentlyAiring
        self.length = length
        self.firebaseShowId = firebaseShowId
        self.pictureUrl = pictureUrl
    }

    init(from: Show) {
        self.id = from.id
        self.created_at = from.created
        self.lastUpdated = from.lastUpdated
        self.name = from.name
        self.service = from.supabaseService
        self.running = from.running
        self.limitedSeries = from.limitedSeries
        self.totalSeasons = from.totalSeasons
        self.releaseDate = nil
        if (from.releaseDate != nil) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let dateString = formatter.string(for: from.releaseDate!)
            if (dateString != nil) { self.releaseDate = dateString! }
        }
        self.airdate = from.airdate
        self.currentlyAiring = from.currentlyAiring
        self.length = from.length
    }
    
}

struct SupabaseShowUpdateDTO : Hashable, Codable, Identifiable {
    var id : Int
    var created_at: Date
    var lastUpdated: Date // Date the show was last updated
    var name: String
    var service: Int
    var running: Bool
    var limitedSeries: Bool
    var totalSeasons: Int
    var releaseDate: String?
    var airdate: String?
    var currentlyAiring: Bool
    var length: String
    var firebaseShowId: String?
    var pictureUrl: String?
    
    init(from: SupabaseShow) {
        self.id = from.id
        self.created_at = from.created_at
        self.lastUpdated = from.lastUpdated
        self.name = from.name
        self.service = from.service.id
        self.running = from.running
        self.limitedSeries = from.limitedSeries
        self.totalSeasons = from.totalSeasons
        self.releaseDate = from.releaseDate
        self.airdate = from.airdate?.rawValue
        self.currentlyAiring = from.currentlyAiring
        self.length = from.length.rawValue
        self.firebaseShowId = from.firebaseShowId
        self.pictureUrl = from.pictureUrl
    }
    
}

var MockSupabaseShow = SupabaseShow(id: 100, created_at: Date(), lastUpdated: Date(), name: "Silicon Valley", service: MockSupabaseService, running: false, limitedSeries: false, totalSeasons: 7, releaseDate: nil, airdate: nil, currentlyAiring: false, length: ShowLength.thirty, firebaseShowId: nil, pictureUrl: "Silicon Valley")

var SupabaseShowProperties = "id, created_at, lastUpdated, name, service (id, createdAt, name, color), running, limitedSeries, totalSeasons, releaseDate, airdate, currentlyAiring, length, firebaseShowId, pictureUrl"

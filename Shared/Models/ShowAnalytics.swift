//
//  ShowAnalytics.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/27/25.
//

import Foundation

struct ShowAnalytics: Codable {
    let showId: Int
    let weeklyUpdates: Int
    let monthlyUpdates: Int
    let yearlyUpdates: Int
    let avgRatingPoints: Double?
    let totalRatings: Int
}

// Properties to select from the show_analytics view
let ShowAnalyticsProperties = "show_id, show_name, service_id, service_name, pictureUrl, running, limitedSeries, totalSeasons, releaseDate, airdate, currentlyAiring, length, weekly_updates, monthly_updates, yearly_updates, avg_rating_points"

// Raw response from Supabase analytics view
struct ShowAnalyticsRow: Codable {
    let show_id: Int
    let show_name: String
    let service_id: Int
    let service_name: String
    let pictureUrl: String?
    let running: Bool
    let limitedSeries: Bool
    let totalSeasons: Int
    let releaseDate: String?
    let airdate: AirDate?
    let currentlyAiring: Bool
    let length: ShowLength
    let weekly_updates: Int
    let monthly_updates: Int
    let yearly_updates: Int
    let avg_rating_points: Double?
}

extension ShowAnalyticsRow {
    func toShow() -> Show {
        let supabaseService = SupabaseService(
            id: service_id,
            createdAt: Date(),
            name: service_name,
            color: nil
        )
        
        let supabaseShow = SupabaseShow(
            id: show_id,
            created_at: Date(),
            lastUpdated: Date(),
            name: show_name,
            service: supabaseService,
            running: running,
            limitedSeries: limitedSeries,
            totalSeasons: totalSeasons,
            releaseDate: releaseDate,
            airdate: airdate,
            currentlyAiring: currentlyAiring,
            length: length,
            firebaseShowId: nil,
            pictureUrl: pictureUrl
        )
        
        return Show(from: supabaseShow)
    }
    
    func toAnalytics() -> ShowAnalytics {
        return ShowAnalytics(
            showId: show_id,
            weeklyUpdates: weekly_updates,
            monthlyUpdates: monthly_updates,
            yearlyUpdates: yearly_updates,
            avgRatingPoints: avg_rating_points,
            totalRatings: 0
        )
    }
} 
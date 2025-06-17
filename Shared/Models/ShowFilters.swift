//
//  ShowFilters.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import Foundation

enum ShowSearchType: Int, CaseIterable {
    case unrestricted = 0
    case watchlist = 1
    case otherUserWatchlist = 2
    case discoverNew = 3
}

enum SortOption: String, CaseIterable {
    case alphabeticalAsc = "alphabetical-asc"
    case alphabeticalDesc = "alphabetical-desc"
    case weeklyPopularityDesc = "weekly_popularity-desc"
    case monthlyPopularityDesc = "monthly_popularity-desc"
    case yearlyPopularityDesc = "yearly_popularity-desc"
    case avgRatingDesc = "avg_rating-desc"
    case avgRatingAsc = "avg_rating-asc"
    case userRatingDesc = "rating-desc"
    case userRatingAsc = "rating-asc"
    
    var ascending: Bool? {
        switch self {
        case .alphabeticalAsc,
                .avgRatingAsc,
                .userRatingAsc:
            return true
        case .alphabeticalDesc,
                .avgRatingDesc,
                .userRatingDesc:
            return false
        default:
            return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .alphabeticalAsc: return "Alphabetical (A-Z)"
        case .alphabeticalDesc: return "Alphabetical (Z-A)"
        case .weeklyPopularityDesc: return "Popularity (Weekly)"
        case .monthlyPopularityDesc: return "Popularity (Monthly)"
        case .yearlyPopularityDesc: return "Popularity (Yearly)"
        case .avgRatingDesc: return "Average Rating (High-Low)"
        case .avgRatingAsc: return "Average Rating (Low-High)"
        case .userRatingDesc: return "Your Rating (High-Low)"
        case .userRatingAsc: return "Your Rating (Low-High)"
        }
    }
    
    var icon: String {
        switch self {
        case .alphabeticalAsc: return "textformat.abc"
        case .alphabeticalDesc: return "textformat.abc"
        case .weeklyPopularityDesc: return "clock"
        case .monthlyPopularityDesc: return "calendar"
        case .yearlyPopularityDesc: return "chart.line.uptrend.xyaxis"
        case .avgRatingDesc, .avgRatingAsc: return "heart.fill"
        case .userRatingDesc: return "hand.thumbsup.fill"
        case .userRatingAsc: return "hand.thumbsdown.fill"
        }
    }
}

struct ShowFilters {
    // Show Properties Filters
    var service: [SupabaseService] = []
    var length: [ShowLength] = []
    var airDate: [AirDate?] = []
    var limitedSeries: Bool? = nil
    var running: Bool? = nil
    var currentlyAiring: Bool? = nil
    var tags: [Tag] = []
    var sortBy: SortOption? = nil
    
    // Current User Filters
    var userRatings: [Rating] = []
    var userStatuses: [Status] = []
    var addedToWatchlist: Bool? = nil
    
    // Other User Filters (for viewing other user's watchlist)
    var otherUserRatings: [Rating] = []
    var otherUserStatuses: [Status] = []
    var otherUserAddedToWatchlist: Bool? = nil
    
    static let `default` = ShowFilters()
    
    var hasActiveFilters: Bool {
        !service.isEmpty ||
        !length.isEmpty ||
        !airDate.isEmpty ||
        limitedSeries != nil ||
        running != nil ||
        currentlyAiring != nil ||
        !tags.isEmpty ||
        !userRatings.isEmpty ||
        !userStatuses.isEmpty ||
        addedToWatchlist != nil ||
        !otherUserRatings.isEmpty ||
        !otherUserStatuses.isEmpty ||
        otherUserAddedToWatchlist != nil
    }
    
    var hasActiveShowFilters: Bool {
        !service.isEmpty ||
        !length.isEmpty ||
        !airDate.isEmpty ||
        limitedSeries != nil ||
        running != nil ||
        currentlyAiring != nil ||
        !tags.isEmpty
    }
    
    var hasActiveCurrentUserFilters: Bool {
        !userRatings.isEmpty ||
        !userStatuses.isEmpty ||
        addedToWatchlist != nil
    }
    
    var hasActiveOtherUserFilters: Bool {
        !otherUserRatings.isEmpty ||
        !otherUserStatuses.isEmpty ||
        otherUserAddedToWatchlist != nil
    }
}

//
//  ShowSearchResult.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/27/25.
//

import Foundation

enum ShowSearchResultItem {
    case showOnly(Show)
    case showWithUserDetails(Show, ShowUserSpecificDetails)
    case showWithAnalytics(Show, ShowAnalytics)
    case showWithUserDetailsAndAnalytics(Show, ShowUserSpecificDetails, ShowAnalytics)
    
    var show: Show {
        switch self {
        case .showOnly(let show):
            return show
        case .showWithUserDetails(let show, _):
            return show
        case .showWithAnalytics(let show, _):
            return show
        case .showWithUserDetailsAndAnalytics(let show, _, _):
            return show
        }
    }
    
    var userDetails: ShowUserSpecificDetails? {
        switch self {
        case .showOnly(_):
            return nil
        case .showWithUserDetails(_, let userDetails):
            return userDetails
        case .showWithAnalytics(_, _):
            return nil
        case .showWithUserDetailsAndAnalytics(_, let userDetails, _):
            return userDetails
        }
    }
    
    var analytics: ShowAnalytics? {
        switch self {
        case .showOnly(_):
            return nil
        case .showWithUserDetails(_, _):
            return nil
        case .showWithAnalytics(_, let analytics):
            return analytics
        case .showWithUserDetailsAndAnalytics(_, _, let analytics):
            return analytics
        }
    }
}

struct ShowSearchResult {
    let items: [ShowSearchResultItem]
    let totalCount: Int
    let currentPage: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    
    // Convenience accessors
    var shows: [Show] {
        items.map { $0.show }
    }
    
    var userDetails: [ShowUserSpecificDetails] {
        items.compactMap { $0.userDetails }
    }
    
    var analytics: [ShowAnalytics] {
        items.compactMap { $0.analytics }
    }
}

// MARK: - Helper Types for Supabase Responses
struct UserShowDataRow: Codable {
    let userDetails: SupabaseShowUserDetails
    let show: SupabaseShow
}

enum ShowSearchError: LocalizedError {
    case missingUserId
    case invalidSearchType
    case supabaseError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingUserId:
            return "User ID is required for this search type"
        case .invalidSearchType:
            return "Invalid search type specified"
        case .supabaseError(let error):
            return "Database error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Data parsing error: \(error.localizedDescription)"
        }
    }
} 
//
//  ShowSearchService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/27/25.
//

import Foundation
import Supabase

struct ShowSearchService {
    
    static func fetchShows(
        filters: ShowFilters,
        searchType: ShowSearchType,
        searchText: String = "",
        currentUserId: String? = nil,
        otherUserId: String? = nil,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> ShowSearchResult {
        
        let offset = (page - 1) * pageSize
        
        switch searchType {
        case .unrestricted:
            return try await fetchUnrestrictedShows(
                filters: filters,
                searchText: searchText,
                offset: offset,
                limit: pageSize
            )
            
        case .watchlist:
            guard let userId = currentUserId else {
                throw ShowSearchError.missingUserId
            }
            return try await fetchWatchlistShows(
                userId: userId,
                filters: filters,
                searchText: searchText,
                offset: offset,
                limit: pageSize
            )
            
        case .otherUserWatchlist:
            guard let userId = otherUserId else {
                throw ShowSearchError.missingUserId
            }
            return try await fetchWatchlistShows(
                userId: userId,
                filters: filters,
                searchText: searchText,
                offset: offset,
                limit: pageSize
            )
            
        case .discoverNew:
            guard let userId = currentUserId else {
                throw ShowSearchError.missingUserId
            }
            return try await fetchDiscoverNewShows(
                excludeUserId: userId,
                filters: filters,
                searchText: searchText,
                offset: offset,
                limit: pageSize
            )
        }
    }
    
    // MARK: - Unrestricted Search
    private static func fetchUnrestrictedShows(
        filters: ShowFilters,
        searchText: String,
        offset: Int,
        limit: Int
    ) async throws -> ShowSearchResult {
        
        // Apply tag filtering first if needed
        let tagFilteredShowIds = try await applyTagFilteringToUnrestrictedShows(filters: filters)
        
        // If tag filtering returned an empty array, return empty results
        if let showIds = tagFilteredShowIds, showIds.isEmpty {
            return ShowSearchResult(
                items: [],
                totalCount: 0,
                currentPage: 1,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false
            )
        }
        
        let needsAnalytics = requiresAnalytics(filters: filters)
        
        if needsAnalytics {
            // First, get analytics data for sorting
            var analyticsQuery = supabase
                .from("show_analytics")
                .select(ShowAnalyticsProperties)
            
            // Apply tag filtering if we have specific show IDs
            if let showIds = tagFilteredShowIds {
                analyticsQuery = analyticsQuery.in("show_id", values: showIds)
            }
            
            // Apply basic filters
            analyticsQuery = applyAnalyticsFilters(query: analyticsQuery, filters: filters)
            
            if !searchText.isEmpty {
                analyticsQuery = analyticsQuery.ilike("show_name", pattern: "%\(searchText)%")
            }
            
            // Apply sorting
            analyticsQuery = applyAnalyticsSorting(
                query: analyticsQuery,
                sortBy: filters.sortBy
            )
            
            // Apply pagination
            analyticsQuery = analyticsQuery.range(from: offset, to: offset + limit - 1) as! PostgrestFilterBuilder
            
            let analyticsResponse: [ShowAnalyticsRow] = try await analyticsQuery.execute().value
            
            // Get the show IDs from analytics results
            let showIds = analyticsResponse.map { $0.show_id }
            
            if showIds.isEmpty {
                return ShowSearchResult(
                    items: [],
                    totalCount: 0,
                    currentPage: 1,
                    totalPages: 1,
                    hasNextPage: false,
                    hasPreviousPage: false
                )
            }
            
            // Now fetch complete show data for these IDs
            let showsQuery = supabase
                .from("show")
                .select(SupabaseShowProperties)
                .in("id", values: showIds)
            
            let showsResponse: [SupabaseShow] = try await showsQuery.execute().value
            
            // Create a mapping of show ID to complete show data
            let showsMap = Dictionary(uniqueKeysWithValues: showsResponse.map { ($0.id, Show(from: $0)) })
            
            // Create items in the same order as analytics results
            let items = analyticsResponse.compactMap { analyticsRow -> ShowSearchResultItem? in
                guard let show = showsMap[analyticsRow.show_id] else { return nil }
                let analytics = analyticsRow.toAnalytics()
                return ShowSearchResultItem.showWithAnalytics(show, analytics)
            }
            
            let totalCount = try await getAnalyticsTotalCount(filters: filters, searchText: searchText, tagFilteredShowIds: tagFilteredShowIds)
            
            return ShowSearchResult(
                items: items,
                totalCount: totalCount,
                currentPage: (offset / limit) + 1,
                totalPages: (totalCount + limit - 1) / limit,
                hasNextPage: offset + limit < totalCount,
                hasPreviousPage: offset > 0
            )
        } else {
            // Use regular show table
            var query = supabase
                .from("show")
                .select(SupabaseShowProperties)
            
            // Apply tag filtering if we have specific show IDs
            if let showIds = tagFilteredShowIds {
                query = query.in("id", values: showIds)
            }
            
            // Apply basic filters
            query = applyShowFilters(query: query, filters: filters)
            
            if !searchText.isEmpty {
                query = query.ilike("name", pattern: "%\(searchText)%")
            }
            
            // Apply sorting
            query = applySorting(query: query, sortBy: filters.sortBy)
            
            // Apply pagination
            query = query.range(from: offset, to: offset + limit - 1) as! PostgrestFilterBuilder
            
            let response: [SupabaseShow] = try await query.execute().value
            
            let items = response.map { supabaseShow in
                let show = Show(from: supabaseShow)
                return ShowSearchResultItem.showOnly(show)
            }
            
            let totalCount = try await getShowTotalCount(filters: filters, searchText: searchText, tagFilteredShowIds: tagFilteredShowIds)
            
            return ShowSearchResult(
                items: items,
                totalCount: totalCount,
                currentPage: (offset / limit) + 1,
                totalPages: (totalCount + limit - 1) / limit,
                hasNextPage: offset + limit < totalCount,
                hasPreviousPage: offset > 0
            )
        }
    }
    
    // MARK: - Watchlist Search (simplified approach)
    private static func fetchWatchlistShows(
        userId: String,
        filters: ShowFilters,
        searchText: String,
        offset: Int,
        limit: Int
    ) async throws -> ShowSearchResult {
        
        // Get user's show details first
        let userShowDetails: [SupabaseShowUserDetails] = try await supabase
            .from("UserShowDetails")
            .select(SupabaseShowUserDetailsProperties)
            .eq("userId", value: userId)
            .execute()
            .value
        
        if userShowDetails.isEmpty {
            return ShowSearchResult(
                items: [],
                totalCount: 0,
                currentPage: 1,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false
            )
        }
        
        // Get the show IDs from user details
        let showIds = userShowDetails.map { $0.showId }
        
        // Apply tag filtering to the user's shows
        let tagFilteredShowIds = try await applyTagFiltering(to: showIds, filters: filters)
        
        // If tag filtering returned an empty array, return empty results
        if tagFilteredShowIds.isEmpty {
            return ShowSearchResult(
                items: [],
                totalCount: 0,
                currentPage: 1,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false
            )
        }
        
        // Determine if we need analytics data
        let needsAnalytics = requiresAnalytics(filters: filters)
        
        var shows: [Show] = []
        var analytics: [Int: ShowAnalytics] = [:]
        
        if needsAnalytics {
            // First, get analytics data
            var analyticsQuery = supabase
                .from("show_analytics")
                .select(ShowAnalyticsProperties)
                .in("show_id", values: tagFilteredShowIds)
            
            analyticsQuery = applyAnalyticsFilters(query: analyticsQuery, filters: filters)
            
            if !searchText.isEmpty {
                analyticsQuery = analyticsQuery.ilike("show_name", pattern: "%\(searchText)%")
            }
            
            let analyticsResponse: [ShowAnalyticsRow] = try await analyticsQuery.execute().value
            
            // Get the show IDs from analytics results
            let analyticsShowIds = analyticsResponse.map { $0.show_id }
            
            if !analyticsShowIds.isEmpty {
                // Now fetch complete show data for these IDs
                let showsQuery = supabase
                    .from("show")
                    .select(SupabaseShowProperties)
                    .in("id", values: analyticsShowIds)
                
                let showsResponse: [SupabaseShow] = try await showsQuery.execute().value
                shows = showsResponse.map { Show(from: $0) }
            }
            
            analytics = Dictionary(uniqueKeysWithValues: analyticsResponse.map { ($0.show_id, $0.toAnalytics()) })
        } else {
            // Get regular shows
            var query = supabase
                .from("show")
                .select(SupabaseShowProperties)
                .in("id", values: tagFilteredShowIds)
            
            query = applyShowFilters(query: query, filters: filters)
            
            if !searchText.isEmpty {
                query = query.ilike("name", pattern: "%\(searchText)%")
            }
            
            let response: [SupabaseShow] = try await query.execute().value
            shows = response.map { Show(from: $0) }
        }
        
        // Create watchlist data by combining shows with user details
        let watchlistData = shows.compactMap { show -> WatchlistData? in
            guard let userDetail = userShowDetails.first(where: { $0.showId == show.id }) else {
                return nil
            }
            let userSpecificDetails = ShowUserSpecificDetails(from: userDetail)
            return WatchlistData(show: show, userDetails: userSpecificDetails)
        }
        
        // Apply client-side filtering for user-specific filters
        let showFilteredData = applyWatchlistFilters(watchlistData, filters: filters, searchText: searchText)
        let filteredData = applyWatchlistUserFilters(showFilteredData, filters: filters)
        
        // Apply sorting
        let sortedData = applyWatchlistSorting(filteredData, sortBy: filters.sortBy, analytics: analytics)
        
        // Apply pagination
        let totalCount = sortedData.count
        let startIndex = offset
        let endIndex = min(startIndex + limit, totalCount)
        let paginatedData = Array(sortedData[startIndex..<endIndex])
        
        let items = paginatedData.map { data in
            if let showAnalytics = analytics[data.show.id] {
                return ShowSearchResultItem.showWithUserDetailsAndAnalytics(data.show, data.userDetails, showAnalytics)
            } else {
                return ShowSearchResultItem.showWithUserDetails(data.show, data.userDetails)
            }
        }
        
        return ShowSearchResult(
            items: items,
            totalCount: totalCount,
            currentPage: (offset / limit) + 1,
            totalPages: (totalCount + limit - 1) / limit,
            hasNextPage: offset + limit < totalCount,
            hasPreviousPage: offset > 0
        )
    }
    
    // MARK: - Discover New Shows
    private static func fetchDiscoverNewShows(
        excludeUserId: String,
        filters: ShowFilters,
        searchText: String,
        offset: Int,
        limit: Int
    ) async throws -> ShowSearchResult {
        
        // First get user's watchlist show IDs
        let userShowIds = try await getUserWatchlistShowIds(userId: excludeUserId)
        
        // Apply tag filtering first if needed
        let tagFilteredShowIds = try await applyTagFilteringToUnrestrictedShows(filters: filters)
        
        // If tag filtering returned an empty array, return empty results
        if let showIds = tagFilteredShowIds, showIds.isEmpty {
            return ShowSearchResult(
                items: [],
                totalCount: 0,
                currentPage: 1,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false
            )
        }
        
        let needsAnalytics = requiresAnalytics(filters: filters)
        
        if needsAnalytics {
            var query = supabase
                .from("show_analytics")
                .select(ShowAnalyticsProperties)
            
            // Apply tag filtering if we have specific show IDs
            if let showIds = tagFilteredShowIds {
                query = query.in("show_id", values: showIds)
            }
            
            // Exclude user's shows
            if !userShowIds.isEmpty {
                query = query.not("show_id", operator: .in, value: userShowIds)
            }
            
            query = applyAnalyticsFilters(query: query, filters: filters)
            
            if !searchText.isEmpty {
                query = query.ilike("show_name", pattern: "%\(searchText)%")
            }
            
            query = applyAnalyticsSorting(query: query, sortBy: filters.sortBy)
            query = query.range(from: offset, to: offset + limit - 1) as! PostgrestFilterBuilder
            
            let response: [ShowAnalyticsRow] = try await query.execute().value
            
            let items = response.map { row in
                let show = row.toShow()
                let analytics = row.toAnalytics()
                return ShowSearchResultItem.showWithAnalytics(show, analytics)
            }
            
            let totalCount = try await getDiscoverNewTotalCount(
                excludeUserId: excludeUserId,
                filters: filters,
                searchText: searchText,
                tagFilteredShowIds: tagFilteredShowIds
            )
            
            return ShowSearchResult(
                items: items,
                totalCount: totalCount,
                currentPage: (offset / limit) + 1,
                totalPages: (totalCount + limit - 1) / limit,
                hasNextPage: offset + limit < totalCount,
                hasPreviousPage: offset > 0
            )
        } else {
            var query = supabase
                .from("show")
                .select(SupabaseShowProperties)
            
            // Apply tag filtering if we have specific show IDs
            if let showIds = tagFilteredShowIds {
                query = query.in("id", values: showIds)
            }
            
            // Exclude user's shows
            if !userShowIds.isEmpty {
                query = query.not("id", operator: .in, value: userShowIds)
            }
            
            query = applyShowFilters(query: query, filters: filters)
            
            if !searchText.isEmpty {
                query = query.ilike("name", pattern: "%\(searchText)%")
            }
            
            query = applySorting(query: query, sortBy: filters.sortBy)
            query = query.range(from: offset, to: offset + limit - 1) as! PostgrestFilterBuilder
            
            let response: [SupabaseShow] = try await query.execute().value
            
            let items = response.map { supabaseShow in
                let show = Show(from: supabaseShow)
                return ShowSearchResultItem.showOnly(show)
            }
            
            let totalCount = try await getDiscoverNewTotalCount(
                excludeUserId: excludeUserId,
                filters: filters,
                searchText: searchText,
                tagFilteredShowIds: tagFilteredShowIds
            )
            
            return ShowSearchResult(
                items: items,
                totalCount: totalCount,
                currentPage: (offset / limit) + 1,
                totalPages: (totalCount + limit - 1) / limit,
                hasNextPage: offset + limit < totalCount,
                hasPreviousPage: offset > 0
            )
        }
    }
}

// MARK: - Helper Functions
extension ShowSearchService {
    
    private static func requiresAnalytics(filters: ShowFilters) -> Bool {
        guard let sortBy = filters.sortBy else { return false }
        return sortBy.rawValue.contains("popularity") || sortBy.rawValue.contains("avg_rating")
    }
    
    // MARK: - Basic Filter Application
    private static func applyShowFilters(
        query: PostgrestFilterBuilder,
        filters: ShowFilters
    ) -> PostgrestFilterBuilder {
        var query = query
        
        if !filters.service.isEmpty {
            let serviceIds = filters.service.map { $0.id }
            query = query.in("service", values: serviceIds)
        }
        
        if !filters.length.isEmpty {
            let lengths = filters.length.map { $0.rawValue }
            query = query.in("length", values: lengths)
        }
        
        if !filters.airDate.isEmpty {
            let airDates = filters.airDate.compactMap { $0?.rawValue }
            query = query.in("airdate", values: airDates)
        }
        
        if let limitedSeries = filters.limitedSeries {
            query = query.eq("limitedSeries", value: limitedSeries)
        }
        
        if let running = filters.running {
            query = query.eq("running", value: running)
        }
        
        if let currentlyAiring = filters.currentlyAiring {
            query = query.eq("currentlyAiring", value: currentlyAiring)
        }
        
        return query
    }
    
    private static func applyAnalyticsFilters(
        query: PostgrestFilterBuilder,
        filters: ShowFilters
    ) -> PostgrestFilterBuilder {
        var query = query
        
        if !filters.service.isEmpty {
            let serviceIds = filters.service.map { $0.id }
            query = query.in("service_id", values: serviceIds)
        }
        
        if !filters.length.isEmpty {
            let lengths = filters.length.map { $0.rawValue }
            query = query.in("length", values: lengths)
        }
        
        if !filters.airDate.isEmpty {
            let airDates = filters.airDate.compactMap { $0?.rawValue }
            query = query.in("airdate", values: airDates)
        }
        
        if let limitedSeries = filters.limitedSeries {
            query = query.eq("limitedSeries", value: limitedSeries)
        }
        
        if let running = filters.running {
            query = query.eq("running", value: running)
        }
        
        if let currentlyAiring = filters.currentlyAiring {
            query = query.eq("currentlyAiring", value: currentlyAiring)
        }
        
        return query
    }
    
    // MARK: - Sorting
    private static func applySorting(
        query: PostgrestFilterBuilder,
        sortBy: SortOption?
    ) -> PostgrestFilterBuilder {
        guard let sortBy = sortBy else {
            return query.order("name", ascending: true) as! PostgrestFilterBuilder
        }
        
        switch sortBy {
        case .alphabeticalAsc:
            return query.order("name", ascending: true) as! PostgrestFilterBuilder
        case .alphabeticalDesc:
            return query.order("name", ascending: false) as! PostgrestFilterBuilder
        default:
            return query.order("name", ascending: true) as! PostgrestFilterBuilder
        }
    }
    
    private static func applyAnalyticsSorting(
        query: PostgrestFilterBuilder,
        sortBy: SortOption?
    ) -> PostgrestFilterBuilder {
        guard let sortBy = sortBy else {
            return query.order("name", ascending: true) as! PostgrestFilterBuilder
        }
        
        switch sortBy {
        case .alphabeticalAsc:
            return query.order("name", ascending: true) as! PostgrestFilterBuilder
        case .alphabeticalDesc:
            return query.order("name", ascending: false) as! PostgrestFilterBuilder
        case .weeklyPopularityDesc:
            return query.order("weekly_updates", ascending: false) as! PostgrestFilterBuilder
        case .monthlyPopularityDesc:
            return query.order("monthly_updates", ascending: false) as! PostgrestFilterBuilder
        case .yearlyPopularityDesc:
            return query.order("yearly_updates", ascending: false) as! PostgrestFilterBuilder
        case .avgRatingDesc:
            return query.order("avg_rating_points", ascending: false, nullsFirst: false) as! PostgrestFilterBuilder
        case .avgRatingAsc:
            return query.order("avg_rating_points", ascending: true, nullsFirst: false) as! PostgrestFilterBuilder
        default:
            return query.order("name", ascending: true) as! PostgrestFilterBuilder
        }
    }
    
    // MARK: - Client-side Watchlist Filtering (like NextJS)
    private static func applyWatchlistFilters(
        _ data: [WatchlistData],
        filters: ShowFilters,
        searchText: String
    ) -> [WatchlistData] {
        var filteredData = data
        
        // Apply search text filter
        if !searchText.isEmpty {
            filteredData = filteredData.filter { item in
                item.show.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply show property filters
        if !filters.service.isEmpty {
            let serviceIds = filters.service.map { $0.id }
            filteredData = filteredData.filter { item in
                serviceIds.contains(item.show.supabaseService.id)
            }
        }
        
        if !filters.length.isEmpty {
            filteredData = filteredData.filter { item in
                filters.length.contains(item.show.length)
            }
        }
        
        if !filters.airDate.isEmpty {
            filteredData = filteredData.filter { item in
                filters.airDate.contains(item.show.airdate)
            }
        }
        
        if let limitedSeries = filters.limitedSeries {
            filteredData = filteredData.filter { item in
                item.show.limitedSeries == limitedSeries
            }
        }
        
        if let running = filters.running {
            filteredData = filteredData.filter { item in
                item.show.running == running
            }
        }
        
        if let currentlyAiring = filters.currentlyAiring {
            filteredData = filteredData.filter { item in
                item.show.currentlyAiring == currentlyAiring
            }
        }
        
        return filteredData
    }
    
    private static func applyWatchlistUserFilters(
        _ data: [WatchlistData],
        filters: ShowFilters
    ) -> [WatchlistData] {
        var filteredData = data
        
        // Apply user-specific filters
        if !filters.userRatings.isEmpty {
            filteredData = filteredData.filter { item in
                guard let rating = item.userDetails.rating else { return false }
                return filters.userRatings.contains(rating)
            }
        }
        
        if !filters.userStatuses.isEmpty {
            let statusIds = filters.userStatuses.map { $0.id }
            filteredData = filteredData.filter { item in
                statusIds.contains(item.userDetails.status.id)
            }
        }
        
        return filteredData
    }
    
    private static func applyWatchlistSorting(
        _ data: [WatchlistData],
        sortBy: SortOption?,
        analytics: [Int: ShowAnalytics]
    ) -> [WatchlistData] {
        guard let sortBy = sortBy else {
            return data.sorted { $0.show.name < $1.show.name }
        }
        
        switch sortBy {
        case .alphabeticalAsc:
            return data.sorted { $0.show.name < $1.show.name }
        case .alphabeticalDesc:
            return data.sorted { $0.show.name > $1.show.name }
        case .userRatingDesc:
            return data.sorted { (a, b) in
                let aRating = a.userDetails.rating?.pointValue ?? Int.min
                let bRating = b.userDetails.rating?.pointValue ?? Int.min
                return aRating > bRating
            }
        case .userRatingAsc:
            return data.sorted { (a, b) in
                let aRating = a.userDetails.rating?.pointValue ?? Int.min
                let bRating = b.userDetails.rating?.pointValue ?? Int.min
                return aRating < bRating
            }
        case .weeklyPopularityDesc:
            return data.sorted { (a, b) in
                let aUpdates = analytics[a.show.id]?.weeklyUpdates ?? 0
                let bUpdates = analytics[b.show.id]?.weeklyUpdates ?? 0
                return aUpdates > bUpdates
            }
        case .monthlyPopularityDesc:
            return data.sorted { (a, b) in
                let aUpdates = analytics[a.show.id]?.monthlyUpdates ?? 0
                let bUpdates = analytics[b.show.id]?.monthlyUpdates ?? 0
                return aUpdates > bUpdates
            }
        case .yearlyPopularityDesc:
            return data.sorted { (a, b) in
                let aUpdates = analytics[a.show.id]?.yearlyUpdates ?? 0
                let bUpdates = analytics[b.show.id]?.yearlyUpdates ?? 0
                return aUpdates > bUpdates
            }
        case .avgRatingDesc:
            return data.sorted { (a, b) in
                let aRating = analytics[a.show.id]?.avgRatingPoints ?? 0
                let bRating = analytics[b.show.id]?.avgRatingPoints ?? 0
                return aRating > bRating
            }
        case .avgRatingAsc:
            return data.sorted { (a, b) in
                let aRating = analytics[a.show.id]?.avgRatingPoints ?? 0
                let bRating = analytics[b.show.id]?.avgRatingPoints ?? 0
                return aRating < bRating
            }
        default:
            return data.sorted { $0.show.name < $1.show.name }
        }
    }
    
    // MARK: - Count Functions
    private static func getShowTotalCount(
        filters: ShowFilters,
        searchText: String,
        tagFilteredShowIds: [Int]? = nil
    ) async throws -> Int {
        var query = supabase
            .from("show")
            .select("id", count: .exact)
        
        query = applyShowFilters(query: query, filters: filters)
        
        if !searchText.isEmpty {
            query = query.ilike("name", pattern: "%\(searchText)%")
        }
        
        if let showIds = tagFilteredShowIds {
            query = query.in("id", values: showIds)
        }
        
        let response = try await query.execute()
        return response.count ?? 0
    }
    
    private static func getAnalyticsTotalCount(
        filters: ShowFilters,
        searchText: String,
        tagFilteredShowIds: [Int]? = nil
    ) async throws -> Int {
        var query = supabase
            .from("show_analytics")
            .select("show_id", count: .exact)
        
        query = applyAnalyticsFilters(query: query, filters: filters)
        
        if !searchText.isEmpty {
            query = query.ilike("show_name", pattern: "%\(searchText)%")
        }
        
        if let showIds = tagFilteredShowIds {
            query = query.in("show_id", values: showIds)
        }
        
        let response = try await query.execute()
        return response.count ?? 0
    }
    
    private static func getDiscoverNewTotalCount(
        excludeUserId: String,
        filters: ShowFilters,
        searchText: String,
        tagFilteredShowIds: [Int]? = nil
    ) async throws -> Int {
        let userShowIds = try await getUserWatchlistShowIds(userId: excludeUserId)
        
        let needsAnalytics = requiresAnalytics(filters: filters)
        
        if needsAnalytics {
            var query = supabase
                .from("show_analytics")
                .select("show_id", count: .exact)
            
            // Apply tag filtering if we have specific show IDs
            if let showIds = tagFilteredShowIds {
                query = query.in("show_id", values: showIds)
            }
            
            if !userShowIds.isEmpty {
                query = query.not("show_id", operator: .in, value: userShowIds)
            }
            
            query = applyAnalyticsFilters(query: query, filters: filters)
            
            if !searchText.isEmpty {
                query = query.ilike("show_name", pattern: "%\(searchText)%")
            }
            
            let response = try await query.execute()
            return response.count ?? 0
        } else {
            var query = supabase
                .from("show")
                .select("id", count: .exact)
            
            // Apply tag filtering if we have specific show IDs
            if let showIds = tagFilteredShowIds {
                query = query.in("id", values: showIds)
            }
            
            if !userShowIds.isEmpty {
                query = query.not("id", operator: .in, value: userShowIds)
            }
            
            query = applyShowFilters(query: query, filters: filters)
            
            if !searchText.isEmpty {
                query = query.ilike("name", pattern: "%\(searchText)%")
            }
            
            let response = try await query.execute()
            return response.count ?? 0
        }
    }
    
    private static func getUserWatchlistShowIds(userId: String) async throws -> [Int] {
        let response: [SupabaseShowUserDetails] = try await supabase
            .from("UserShowDetails")
            .select("showId")
            .eq("userId", value: userId)
            .execute()
            .value
        
        return response.map { $0.showId }
    }
    
    // MARK: - Tag Filtering
    private static func applyTagFiltering(
        to showIds: [Int],
        filters: ShowFilters
    ) async throws -> [Int] {
        guard !filters.tags.isEmpty else {
            return showIds
        }
        
        let tagIds = filters.tags.map { $0.id }
        
        // Query ShowTagRelationship to find shows with these tags
        let tagRelationships: [SupabaseShowTagRelationship] = try await supabase
            .from("ShowTagRelationship")
            .select("showId, tagId")
            .in("showId", values: showIds)
            .in("tagId", values: tagIds)
            .execute()
            .value
        
        if tagRelationships.isEmpty {
            return [] // No shows match the selected tags
        }
        
        // Get unique show IDs that have any of the selected tags
        let showIdsWithTags = Array(Set(tagRelationships.map { $0.showId }))
        
        return showIdsWithTags
    }
    
    private static func applyTagFilteringToUnrestrictedShows(
        filters: ShowFilters
    ) async throws -> [Int]? {
        guard !filters.tags.isEmpty else {
            return nil // No tag filtering needed
        }
        
        let tagIds = filters.tags.map { $0.id }
        
        // Query ShowTagRelationship to find all shows with these tags
        let tagRelationships: [SupabaseShowTagRelationship] = try await supabase
            .from("ShowTagRelationship")
            .select("showId, tagId")
            .in("tagId", values: tagIds)
            .execute()
            .value
        
        if tagRelationships.isEmpty {
            return [] // No shows match the selected tags
        }
        
        // Get unique show IDs that have any of the selected tags
        let showIdsWithTags = Array(Set(tagRelationships.map { $0.showId }))
        
        return showIdsWithTags
    }
}

// MARK: - Supporting Types
struct WatchlistData {
    let show: Show
    let userDetails: ShowUserSpecificDetails
}

// MARK: - Multi-User Data Fetching
extension ShowSearchService {
    static func fetchMultiUserData(for showIds: [Int]) async -> [ShowMultiUserData] {
        guard !showIds.isEmpty else { return [] }
        
        return await withTaskGroup(of: ShowMultiUserData.self) { group in
            // Add a task for each show ID
            for showId in showIds {
                group.addTask {
                    await getMultiUserShowData(showId: showId)
                }
            }
            
            // Collect all results
            var results: [ShowMultiUserData] = []
            for await multiUserData in group {
                results.append(multiUserData)
            }
            
            return results
        }
    }
}


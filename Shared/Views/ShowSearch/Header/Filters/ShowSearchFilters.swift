//
//  ShowSearchFilters.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import SwiftUI

enum FilterTab: String, CaseIterable {
    case showFilters = "Show Filters"
    case currentUserFilters = "My Filters"
    case otherUserFilters = "Their Filters"
}

struct ShowSearchFilters: View {
    
    @EnvironmentObject var modelData: ModelData
    @Binding var filters: ShowFilters
    
    let searchType: ShowSearchType
    let currentUserId: String?
    let otherUserId: String?
    
    @State private var selectedTab: FilterTab = .showFilters
    
    init(
        filters: Binding<ShowFilters>,
        searchType: ShowSearchType = .unrestricted,
        currentUserId: String? = nil,
        otherUserId: String? = nil
    ) {
        self._filters = filters
        self.searchType = searchType
        self.currentUserId = currentUserId
        self.otherUserId = otherUserId
    }
    
    private var availableTabs: [FilterTab] {
        var tabs: [FilterTab] = [.showFilters]
        
        // Add current user filters for watchlist and discover new searches
        if searchType == .watchlist || searchType == .discoverNew {
            tabs.append(.currentUserFilters)
        }
        
        // Add other user filters when viewing another user's watchlist
        if searchType == .otherUserWatchlist && currentUserId != otherUserId {
            tabs.append(.otherUserFilters)
        }
        
        return tabs
    }
    
    private func clearAllFilters() {
        filters = ShowFilters.default
    }
    
    private var hasActiveFilters: Bool {
        filters.hasActiveFilters
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Picker
            if availableTabs.count > 1 {
                Picker("Filter Type", selection: $selectedTab) {
                    ForEach(availableTabs, id: \.self) { tab in
                        HStack {
                            Text(tab.rawValue)
                            if hasActiveFiltersForTab(tab) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .glassEffect()
                .padding(.horizontal)
                .padding(.top)
            }
            
            // Clear All Filters Button
            HStack {
                Spacer()
                Button(action: clearAllFilters) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Clear All Filters")
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.red)
                .disabled(!hasActiveFilters)
            }
            .padding(.horizontal)
            .padding(.top, availableTabs.count > 1 ? 8 : 16)
            
            // Tab Content
            ScrollView {
                VStack(spacing: 16) {
                    switch selectedTab {
                    case .showFilters:
                        ShowFiltersTab(filters: $filters, modelData: modelData)
                    case .currentUserFilters:
                        CurrentUserFiltersTab(filters: $filters, modelData: modelData)
                    case .otherUserFilters:
                        OtherUserFiltersTab(filters: $filters, modelData: modelData)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // Set initial tab based on available tabs
            if !availableTabs.contains(selectedTab) {
                selectedTab = availableTabs.first ?? .showFilters
            }
        }
    }
    
    private func hasActiveFiltersForTab(_ tab: FilterTab) -> Bool {
        switch tab {
        case .showFilters:
            return filters.hasActiveShowFilters
        case .currentUserFilters:
            return filters.hasActiveCurrentUserFilters
        case .otherUserFilters:
            return filters.hasActiveOtherUserFilters
        }
    }
}

// MARK: - Show Filters Tab
struct ShowFiltersTab: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    var body: some View {
        VStack(spacing: 16) {
            ServiceFilter(filters: $filters, modelData: modelData)
            LengthFilter(filters: $filters)
            AirdateFilter(filters: $filters)
            BooleanFiltersSection(filters: $filters)
            TagsFilter(filters: $filters, modelData: modelData)
        }
    }
}

// MARK: - Current User Filters Tab
struct CurrentUserFiltersTab: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    var body: some View {
        VStack(spacing: 16) {
            CurrentUserRatingsFilter(filters: $filters)
            CurrentUserStatusesFilter(filters: $filters, modelData: modelData)
            CurrentUserWatchlistFilter(filters: $filters)
        }
    }
}

// MARK: - Other User Filters Tab
struct OtherUserFiltersTab: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    var body: some View {
        VStack(spacing: 16) {
            OtherUserRatingsFilter(filters: $filters)
            OtherUserStatusesFilter(filters: $filters, modelData: modelData)
            OtherUserWatchlistFilter(filters: $filters)
        }
    }
}

// MARK: - Boolean Filters Section Component
struct BooleanFiltersSection: View {
    @Binding var filters: ShowFilters
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Show Properties")
                .font(.headline)
                .foregroundColor(.primary)
            
            BooleanFilterRow(
                title: "Limited Series:",
                value: $filters.limitedSeries
            )
            
            BooleanFilterRow(
                title: "Running:",
                value: $filters.running
            )
            
            BooleanFilterRow(
                title: "Currently Airing:",
                value: $filters.currentlyAiring
            )
        }
    }
}

// MARK: - Boolean Filter Row Component
struct BooleanFilterRow: View {
    let title: String
    @Binding var value: Bool?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
            HStack(spacing: 8) {
                Button(action: {
                    value = value == true ? nil : true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: value == true ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("Yes")
                            .fixedSize()
                        if value == true {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(value == true ? .green : .gray)
                
                Button(action: {
                    value = value == false ? nil : false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: value == false ? "xmark.circle.fill" : "xmark.circle")
                        Text("No")
                            .fixedSize()
                        if value == false {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(value == false ? .red : .gray)
            }
        }
    }
}

// MARK: - Other User Ratings Filter
struct OtherUserRatingsFilter: View {
    @Binding var filters: ShowFilters
    
    private var allRatings: [Rating] { Rating.allCases }
    private var unselectedRatings: [Rating] {
        allRatings.filter { !filters.otherUserRatings.contains($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Their Ratings")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.otherUserRatings, id: \.self) { rating in
                        Button(action: {
                            filters.otherUserRatings.removeAll { $0 == rating }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: rating.ratingSymbol + ".fill")
                                    .foregroundColor(rating.color)
                                Text(rating.rawValue)
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(rating.color)
                    }
                    
                    ForEach(unselectedRatings, id: \.self) { rating in
                        Button(action: {
                            filters.otherUserRatings.append(rating)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: rating.ratingSymbol)
                                    .foregroundColor(rating.color)
                                Text(rating.rawValue)
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - Other User Statuses Filter
struct OtherUserStatusesFilter: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    private var allStatuses: [Status] { modelData.statuses }
    private var unselectedStatuses: [Status] {
        allStatuses.filter { status in
            !filters.otherUserStatuses.contains { $0.id == status.id }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Their Statuses")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.otherUserStatuses) { status in
                        Button(action: {
                            filters.otherUserStatuses.removeAll { $0.id == status.id }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: status.icon)
                                Text(status.name)
                                    .fixedSize()
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                    }
                    
                    ForEach(unselectedStatuses) { status in
                        Button(action: {
                            filters.otherUserStatuses.append(status)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: status.icon)
                                Text(status.name)
                                    .fixedSize()
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - Other User Watchlist Filter
struct OtherUserWatchlistFilter: View {
    @Binding var filters: ShowFilters
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Added to Their Watchlist")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                Button(action: {
                    filters.otherUserAddedToWatchlist = filters.otherUserAddedToWatchlist == true ? nil : true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: filters.otherUserAddedToWatchlist == true ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("Yes")
                            .fixedSize()
                        if filters.otherUserAddedToWatchlist == true {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(filters.otherUserAddedToWatchlist == true ? .green : .gray)
                
                Button(action: {
                    filters.otherUserAddedToWatchlist = filters.otherUserAddedToWatchlist == false ? nil : false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: filters.otherUserAddedToWatchlist == false ? "xmark.circle.fill" : "xmark.circle")
                        Text("No")
                            .fixedSize()
                        if filters.otherUserAddedToWatchlist == false {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(filters.otherUserAddedToWatchlist == false ? .red : .gray)
                
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var filters = ShowFilters.default
    return ShowSearchFilters(
        filters: $filters,
        searchType: .otherUserWatchlist,
        currentUserId: "user1",
        otherUserId: "user2"
    )
    .environmentObject(ModelData())
}

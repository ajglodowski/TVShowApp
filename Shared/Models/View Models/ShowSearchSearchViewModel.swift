//
//  ShowSearchSearchViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/27/25.
//

import Foundation

class ShowSearchViewModel: ObservableObject {
    
    // Published Properties
    @Published var searchResults: [Show] = []
    @Published var multiUserData: [ShowMultiUserData] = []
    @Published var isLoading: Bool = true
    @Published var searchText: String = "" {
        didSet {
            performSearch()
        }
    }
    @Published var filters: ShowFilters = ShowFilters.default {
        didSet {
            Task { @MainActor in
                setCurrentPage(1) // Reset to first page when filters change
            }
            performSearch()
        }
    }
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var totalResults: Int = 0
    @Published var errorMessage: String?
    
    // Configuration
    private let pageSize: Int = 20
    private var searchType: ShowSearchType = .unrestricted
    private var currentUserId: String?
    private var otherUserId: String?
    
    // Debouncing
    private var searchTask: Task<Void, Never>?
    private let searchDebounceTime: TimeInterval = 0.5
    
    // Current search result with full data
    private var currentSearchResult: ShowSearchResult?
    
    // MARK: - Published Property Setters
    @MainActor
    private func setSearchResults(_ results: [Show]) {
        searchResults = results
    }
    
    @MainActor
    private func setMultiUserData(_ data: [ShowMultiUserData]) {
        multiUserData = data
    }
    
    @MainActor
    private func setIsLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    @MainActor
    private func setSearchTextInternal(_ text: String) {
        searchText = text
    }
    
    @MainActor
    private func setFiltersInternal(_ newFilters: ShowFilters) {
        filters = newFilters
    }
    
    @MainActor
    private func setCurrentPage(_ page: Int) {
        currentPage = page
    }
    
    @MainActor
    private func setTotalPages(_ pages: Int) {
        totalPages = pages
    }
    
    @MainActor
    private func setTotalResults(_ results: Int) {
        totalResults = results
    }
    
    @MainActor
    private func setErrorMessage(_ message: String?) {
        errorMessage = message
    }
    
    // MARK: - Configuration
    func configure(
        searchType: ShowSearchType,
        currentUserId: String? = nil,
        otherUserId: String? = nil
    ) {
        self.searchType = searchType
        self.currentUserId = currentUserId
        self.otherUserId = otherUserId
        
        // Perform initial search
        performSearch()
    }
    
    // MARK: - Search Methods
    func performSearch() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(searchDebounceTime * 1_000_000_000))
            
            guard !Task.isCancelled else { return }
            await executeSearch()
        }
    }
    
    private func executeSearch() async {
        await setIsLoading(true)
        await setErrorMessage(nil)
        
        do {
            let result = try await ShowSearchService.fetchShows(
                filters: filters,
                searchType: searchType,
                searchText: searchText,
                currentUserId: currentUserId,
                otherUserId: otherUserId,
                page: currentPage,
                pageSize: pageSize
            )
            
            let showIdList = result.shows.map { $0.id }
            
            currentSearchResult = result
            await setSearchResults(result.shows)
            await setTotalPages(result.totalPages)
            await setTotalResults(result.totalCount)
            
            // Fetch multi-user data concurrently for all shows
            let multiUserDataResults = await ShowSearchService.fetchMultiUserData(for: showIdList)
            await setMultiUserData(multiUserDataResults)
            
        } catch {
            await setErrorMessage(error.localizedDescription)
            await setSearchResults([])
            await setMultiUserData([])
            currentSearchResult = nil
        }
        
        await setIsLoading(false)
    }
    
    // MARK: - Pagination Methods
    func loadNextPage() async {
        guard currentPage < totalPages, !isLoading else { return }
        await setCurrentPage(currentPage + 1)
        await executeSearch()
    }
    
    func loadPreviousPage() async {
        guard currentPage > 1, !isLoading else { return }
        await setCurrentPage(currentPage - 1)
        await executeSearch()
    }
    
    func goToPage(_ page: Int) async {
        guard page >= 1 && page <= totalPages, page != currentPage, !isLoading else { return }
        await setCurrentPage(page)
        await executeSearch()
    }
    
    // MARK: - Filter Management
    @MainActor
    func updateFilters(_ newFilters: ShowFilters) {
        filters = newFilters
    }
    
    @MainActor
    func clearAllFilters() {
        filters = ShowFilters.default
    }
    
    @MainActor
    func addServiceFilter(_ service: SupabaseService) {
        if !filters.service.contains(service) {
            var newFilters = filters
            newFilters.service.append(service)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeServiceFilter(_ service: SupabaseService) {
        var newFilters = filters
        newFilters.service.removeAll { $0.id == service.id }
        filters = newFilters
    }
    
    @MainActor
    func addLengthFilter(_ length: ShowLength) {
        if !filters.length.contains(length) {
            var newFilters = filters
            newFilters.length.append(length)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeLengthFilter(_ length: ShowLength) {
        var newFilters = filters
        newFilters.length.removeAll { $0 == length }
        filters = newFilters
    }
    
    @MainActor
    func addAirDateFilter(_ airDate: AirDate?) {
        if !filters.airDate.contains(airDate) {
            var newFilters = filters
            newFilters.airDate.append(airDate)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeAirDateFilter(_ airDate: AirDate?) {
        var newFilters = filters
        newFilters.airDate.removeAll { $0 == airDate }
        filters = newFilters
    }
    
    @MainActor
    func addTagFilter(_ tag: Tag) {
        if !filters.tags.contains(where: { $0.id == tag.id }) {
            var newFilters = filters
            newFilters.tags.append(tag)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeTagFilter(_ tag: Tag) {
        var newFilters = filters
        newFilters.tags.removeAll { $0.id == tag.id }
        filters = newFilters
    }
    
    @MainActor
    func setSortOption(_ sortOption: SortOption?) {
        var newFilters = filters
        newFilters.sortBy = sortOption
        filters = newFilters
    }
    
    // MARK: - Current User Filter Management
    @MainActor
    func addUserRatingFilter(_ rating: Rating) {
        if !filters.userRatings.contains(rating) {
            var newFilters = filters
            newFilters.userRatings.append(rating)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeUserRatingFilter(_ rating: Rating) {
        var newFilters = filters
        newFilters.userRatings.removeAll { $0 == rating }
        filters = newFilters
    }
    
    @MainActor
    func addUserStatusFilter(_ status: Status) {
        if !filters.userStatuses.contains(where: { $0.id == status.id }) {
            var newFilters = filters
            newFilters.userStatuses.append(status)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeUserStatusFilter(_ status: Status) {
        var newFilters = filters
        newFilters.userStatuses.removeAll { $0.id == status.id }
        filters = newFilters
    }
    
    @MainActor
    func setAddedToWatchlist(_ value: Bool?) {
        var newFilters = filters
        newFilters.addedToWatchlist = value
        filters = newFilters
    }
    
    // MARK: - Other User Filter Management
    @MainActor
    func addOtherUserRatingFilter(_ rating: Rating) {
        if !filters.otherUserRatings.contains(rating) {
            var newFilters = filters
            newFilters.otherUserRatings.append(rating)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeOtherUserRatingFilter(_ rating: Rating) {
        var newFilters = filters
        newFilters.otherUserRatings.removeAll { $0 == rating }
        filters = newFilters
    }
    
    @MainActor
    func addOtherUserStatusFilter(_ status: Status) {
        if !filters.otherUserStatuses.contains(where: { $0.id == status.id }) {
            var newFilters = filters
            newFilters.otherUserStatuses.append(status)
            filters = newFilters
        }
    }
    
    @MainActor
    func removeOtherUserStatusFilter(_ status: Status) {
        var newFilters = filters
        newFilters.otherUserStatuses.removeAll { $0.id == status.id }
        filters = newFilters
    }
    
    @MainActor
    func setOtherUserAddedToWatchlist(_ value: Bool?) {
        var newFilters = filters
        newFilters.otherUserAddedToWatchlist = value
        filters = newFilters
    }
    
    // MARK: - Computed Properties
    var hasNextPage: Bool {
        currentPage < totalPages
    }
    
    var hasPreviousPage: Bool {
        currentPage > 1
    }
    
    var hasActiveFilters: Bool {
        filters.hasActiveFilters
    }
    
    var isEmpty: Bool {
        searchResults.isEmpty && !isLoading
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
    
    // MARK: - User Details Access (for watchlist views)
    func getUserDetails(for show: Show) -> ShowUserSpecificDetails? {
        guard let result = currentSearchResult else { return nil }
        
        return result.items.first { item in
            item.show.id == show.id
        }?.userDetails
    }
    
    func getAnalytics(for show: Show) -> ShowAnalytics? {
        guard let result = currentSearchResult else { return nil }
        
        return result.items.first { item in
            item.show.id == show.id
        }?.analytics
    }
    
    // MARK: - Search Text Management
    @MainActor
    func updateSearchText(_ text: String) {
        searchText = text
    }
    
    @MainActor
    func clearSearchText() {
        searchText = ""
    }
    
    // MARK: - Refresh
    func refresh() async {
        await setCurrentPage(1)
        await executeSearch()
    }
    
    // MARK: - Legacy Support (for existing code)
    func findShows(searchText: String) async {
        await setSearchTextInternal(searchText)
        await executeSearch()
    }
    
    @MainActor
    func setSearchResults(shows: [Show]) {
        searchResults = shows
    }
}

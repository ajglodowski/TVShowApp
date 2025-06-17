//
//  ShowSearch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import SwiftUI

struct ShowSearch: View {
    
    @StateObject private var viewModel = ShowSearchViewModel()
    @State private var showFilters = false
    
    let searchType: ShowSearchType
    let currentUserId: String?
    let otherUserId: String?
    let pageTitle: String?
    let includeNavigation: Bool
    
    init(
        searchType: ShowSearchType = .unrestricted,
        currentUserId: String? = nil,
        otherUserId: String? = nil,
        pageTitle: String? = nil,
        initialFilters: ShowFilters? = nil,
        includeNavigation: Bool = true
    ) {
        self.searchType = searchType
        self.currentUserId = currentUserId
        self.otherUserId = otherUserId
        self.pageTitle = pageTitle
        self.includeNavigation = includeNavigation
        
        if let filters = initialFilters {
            self._viewModel = StateObject(wrappedValue: {
                let vm = ShowSearchViewModel()
                vm.filters = filters
                return vm
            }())
        }
    }
    
    var body: some View {
        if includeNavigation {
            NavigationView {
                ShowSearchContent(
                    viewModel: viewModel,
                    showFilters: $showFilters,
                    searchType: searchType,
                    currentUserId: currentUserId,
                    otherUserId: otherUserId,
                    pageTitle: pageTitle
                )
            }
        } else {
            ShowSearchContent(
                viewModel: viewModel,
                showFilters: $showFilters,
                searchType: searchType,
                currentUserId: currentUserId,
                otherUserId: otherUserId,
                pageTitle: pageTitle
            )
        }
    }
}

// MARK: - Search Content Component
struct ShowSearchContent: View {
        
    @Namespace var animation
    
    @ObservedObject var viewModel: ShowSearchViewModel
    @Binding var showFilters: Bool
    
    var searchText: Binding<String> { $viewModel.searchText }
    
    let searchType: ShowSearchType
    let currentUserId: String?
    let otherUserId: String?
    let pageTitle: String?
    
    var body: some View {
        ShowSearchResultsList(
            searchText: searchText,
            shows: viewModel.searchResults,
            multiUserData: viewModel.multiUserData,
            isLoading: viewModel.isLoading,
            errorMessage: viewModel.errorMessage,
            isEmpty: viewModel.isEmpty,
            searchType: searchType,
            viewModel: viewModel
        )
        .searchToolbarBehavior(.minimize)
        .navigationTitle(pageTitle ?? "Search Shows")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                SortButton(
                    currentSort: viewModel.filters.sortBy,
                    action: { sortOption in
                        viewModel.setSortOption(sortOption)
                    }
                )
            }
            
            ToolbarItem {
                FilterButton(
                    hasActiveFilters: viewModel.filters.hasActiveFilters,
                    action: { showFilters = true }
                )
                .matchedTransitionSource(id: "filter", in: animation)
            }
            
            ToolbarItem(placement: .status) {
                HStack(spacing: 0) {
                    Button(action: {
                        Task { await viewModel.loadPreviousPage() }
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!viewModel.hasPreviousPage)
                    
                    VStack {
                        if (viewModel.isLoading) {
                            HStack {
                                ProgressView()
                            }.font(.caption)
                            
                        } else {
                            Text("\(viewModel.totalResults) result\(viewModel.totalResults == 1 ? "" : "s")")
                                .font(.caption)
                                .frame(minWidth: 96)
                            
                            Text("Page \(viewModel.currentPage)/\(viewModel.totalPages)")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .frame(minWidth: 96)
                        }
                    }
                    
                    Button(action: {
                         Task { await viewModel.loadNextPage() }
                     }) {
                         Image(systemName: "chevron.right")
                     }
                     .disabled(!viewModel.hasNextPage)
                }
             }
        
        }
        .sheet(isPresented: $showFilters) {
            NavigationView {
                ShowSearchFilters(
                    filters: $viewModel.filters,
                    searchType: searchType,
                    currentUserId: currentUserId,
                    otherUserId: otherUserId
                )
                .navigationTitle("Filters")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showFilters = false
                        }
                    }
                }
            }
            .navigationTransition(.zoom(sourceID: "filter", in: animation))
        }
        .onAppear {
            viewModel.configure(
                searchType: searchType,
                currentUserId: currentUserId,
                otherUserId: otherUserId
            )
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}


// MARK: - Search Bar Component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search shows...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}





// MARK: - Results Count Component
struct ResultsCountView: View {
    let count: Int
    let isLoading: Bool
    
    var body: some View {
        HStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                Text("Searching...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("\(count) result\(count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

// MARK: - Results List Component
struct ShowSearchResultsList: View {
    let searchText: Binding<String>
    let shows: [Show]
    let multiUserData: [ShowMultiUserData]
    let isLoading: Bool
    let errorMessage: String?
    let isEmpty: Bool
    let searchType: ShowSearchType
    let viewModel: ShowSearchViewModel
    
    func getMultiUserData(showId: Int) -> ShowMultiUserData? {
        multiUserData.first { $0.showId == showId }
    }
    
    var body: some View {
        if isLoading && shows.isEmpty {
            ShowSearchLoadingView()
        } else if let error = errorMessage {
            ErrorView(message: error) {
                Task { await viewModel.refresh() }
            }
        } else if isEmpty {
            EmptyStateView(searchType: searchType)
        } else {
            List(shows) { show in
                NavigationLink(destination: ShowDetail(showId: show.id)) {
                    ListShowRow(show: show, loadUserData: false, alreadyLoadedMultiUserData: getMultiUserData(showId: show.id))
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .searchable(text: searchText)
        }
    }
}

// MARK: - Show Search Row Component
struct ShowSearchRow: View {
    let show: Show
    let loadedMultiUserData: ShowMultiUserData?
    let searchType: ShowSearchType
    
    var body: some View {
        ListShowRow(show: show, loadUserData: false, alreadyLoadedMultiUserData: loadedMultiUserData)
    }
}

// MARK: - Loading View Component
struct ShowSearchLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Searching shows...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error View Component
struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again", action: retry)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Empty State View Component
struct EmptyStateView: View {
    let searchType: ShowSearchType
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: emptyStateIcon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(emptyStateTitle)
                .font(.headline)
            
            Text(emptyStateMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateIcon: String {
        switch searchType {
        case .unrestricted:
            return "tv"
        case .watchlist:
            return "heart"
        case .otherUserWatchlist:
            return "person.2"
        case .discoverNew:
            return "sparkles"
        }
    }
    
    private var emptyStateTitle: String {
        switch searchType {
        case .unrestricted:
            return "No shows found"
        case .watchlist:
            return "No shows in watchlist"
        case .otherUserWatchlist:
            return "No shows in their watchlist"
        case .discoverNew:
            return "No new shows to discover"
        }
    }
    
    private var emptyStateMessage: String {
        switch searchType {
        case .unrestricted:
            return "Try adjusting your search terms or filters"
        case .watchlist:
            return "Add some shows to your watchlist to see them here"
        case .otherUserWatchlist:
            return "This user hasn't added any shows matching your criteria"
        case .discoverNew:
            return "You've seen everything! Try different filters to find more shows"
        }
    }
}

#Preview {
    ShowSearch()
        .environmentObject(ModelData())
}


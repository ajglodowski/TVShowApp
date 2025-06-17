//
//  ShowSearchHeader.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/8/25.
//
import SwiftUI

struct ShowSearchHeader: View {
    @Binding var searchText: String
    @Binding var filters: ShowFilters
    let totalResults: Int
    @Binding var showFilters: Bool
    let isLoading: Bool
    let currentPage: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let onSortChange: (SortOption?) -> Void
    let onPreviousPage: () -> Void
    let onNextPage: () -> Void
    let filterAnimationNamespace: Namespace.ID
    
    var body: some View {
        EmptyView()
    }
}

#Preview {
    @State var searchText = ""
    @State var filters = ShowFilters()
    @State var showFilters = false
    @State var isLoading = false
    @State var currentPage = 1
    @State var totalPages = 1
    @State var hasNextPage = false
    @State var hasPreviousPage = false
    func onSortChange(_ sortOption: SortOption?) {  
        print("Sort changed to \(sortOption?.displayName ?? "None")")
    }
    func onPreviousPage() {
        print("Previous page")
    }
    func onNextPage() {
        print("Next page")
    }
    @Namespace var animation
    
    return VStack {
        ShowSearchHeader(
            searchText: $searchText,
            filters: $filters,
            totalResults: 0,
            showFilters: $showFilters,
            isLoading: isLoading,
            currentPage: currentPage,
            totalPages: totalPages,
            hasNextPage: hasNextPage,
            hasPreviousPage: hasPreviousPage,
            onSortChange: onSortChange,
            onPreviousPage: onPreviousPage,
            onNextPage: onNextPage,
            filterAnimationNamespace: animation
        )
    }
    //.background(.blue)
}

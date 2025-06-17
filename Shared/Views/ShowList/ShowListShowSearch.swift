//
//  ShowListShowSearch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/25/24.
//

import SwiftUI

struct ShowListShowSearch: View {
    
    @StateObject var showSearchVm = SearchShowViewModel()
    
    @Binding var editingShows: [Show]
    
    @State var searchText: String = ""
    
    var searchResults: [Show]? { showSearchVm.searchResults }
    var addShowSearchReturned: [Show] {
        if (searchResults == nil) { return [] }
        return searchResults!.filter { result in
            !editingShows.contains { editingShow in
                editingShow.id == result.id
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Search for a new show to add")
                .font(.title)
            HStack { // Search Bar
                Image(systemName: "magnifyingglass")
                TextField("Search for a show", text: $searchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                if (!searchText.isEmpty) {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            if (!searchText.isEmpty) {
                ForEach(addShowSearchReturned) { show in
                    HStack {
                        ListShowRow(show: show)
                        Spacer()
                        Button(action: {
                            editingShows.append(show)
                        }) {
                            HStack(spacing:0) {
                                Image(systemName: "plus")
                                Text("Add")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
        }
        .task(id: searchText) {
            await showSearchVm.findShows(searchText: searchText)
        }
        .padding(5)
        .cornerRadius(5.0)
    }
}

#Preview {
    @State var shows: [Show] = []
    return ShowListShowSearch(editingShows: $shows)
}

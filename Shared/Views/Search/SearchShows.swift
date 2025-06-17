//
//  ShowSearch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/3/23.
//

import SwiftUI

struct SearchShows: View {
    
    @StateObject var showSearchVm = SearchShowViewModel()
    
    @State var searchText: String = ""
    
    var searchResults: [Show] { showSearchVm.searchResults ?? [] }
    
    var body: some View {
        VStack {
            List {
                ForEach(searchResults) { show in
                    ListShowRow(show: show)
                }
            }
            .searchable(text: $searchText)
        }
        .task(id: searchText) {
            await showSearchVm.findShows(searchText: searchText)
        }
    }

}

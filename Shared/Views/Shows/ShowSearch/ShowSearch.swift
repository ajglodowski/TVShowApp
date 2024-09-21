//
//  ShowSearch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import SwiftUI

struct ShowSearch: View {
    
    @State var showFilters : ShowFilters
    
    init(showFilters: ShowFilters? = nil) {
        if (showFilters != nil) { self.showFilters = showFilters! }
        else { self.showFilters = ShowFilters(service: [], length: [], airDate: []) }
    }
    
    var body: some View {
        VStack {
            ShowSearchFilters(filters: $showFilters)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    ShowSearch()
        .environmentObject(ModelData())
}

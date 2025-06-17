//
//  WatchList.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine

struct WatchList: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ShowSearch(
            searchType: ShowSearchType.watchlist, 
            currentUserId: modelData.currentUser?.id,
            includeNavigation: false
        )
    }
    
}

#Preview {
    return WatchList()
        .environmentObject(ModelData())
}

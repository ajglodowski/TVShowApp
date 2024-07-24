//
//  HomeStatusFiltered.swift
//  TV Show App
//
//  Created by AJ Glodowski on 2/3/23.
//

import SwiftUI

struct HomeStatusFiltered: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var statuses: [Status] { modelData.statuses }
    
    @State var selectedStatus: Status? = nil
    
    var shows: [Show]
    
    var displayedShows: [Show] {
        let userShows = shows.filter { $0.addedToUserShows }
        var output = userShows.sorted { $0.userSpecificValues!.updated > $1.userSpecificValues!.updated }
        if (selectedStatus != nil) { output = output.filter { $0.userSpecificValues!.status == selectedStatus } }
        return Array(output.prefix(10))
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(statuses) { status in
                        Button(action: {
                            if (selectedStatus != status) { selectedStatus = status }
                            else { selectedStatus = nil }
                        }) {
                            Text(status.name)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(status == selectedStatus ? .blue : .secondary)
                        .buttonBorderShape(.capsule)
                    }
                }
                .foregroundColor(.white)
            }
            if (displayedShows.isEmpty) { Text("No shows with this status 😞") }
            else { VStack { SquareTileScrollRow(items: displayedShows, scrollType: ScrollRowType.NoExtraText) } }
        }
    }
}



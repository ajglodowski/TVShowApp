//
//  HomeStatusFiltered.swift
//  TV Show App
//
//  Created by AJ Glodowski on 2/3/23.
//

import SwiftUI

struct HomeStatusFiltered: View {
    
    @State var selectedStatus: Status? = nil
    
    var shows: [Show]
    
    var displayedShows: [Show] {
        var output = shows.sorted { $0.userSpecificValues!.lastUpdateDate ?? Date(timeIntervalSince1970: 0) > $1.userSpecificValues!.lastUpdateDate ?? Date(timeIntervalSince1970: 0) }
        if (selectedStatus != nil) { output = output.filter { $0.userSpecificValues!.status == selectedStatus } }
        return Array(output.prefix(10))
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Status.allCases.sorted { $0.order < $1.order }) { status in
                        Button(action: {
                            if (selectedStatus != status) { selectedStatus = status }
                            else { selectedStatus = nil }
                        }) {
                            Text(status.rawValue)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(status == selectedStatus ? .blue : .secondary)
                        .buttonBorderShape(.capsule)
                    }
                }
                .foregroundColor(.white)
            }
            if (displayedShows.isEmpty) { Text("No shows with this status 😞") }
            else { VStack { SquareTileScrollRow(items: displayedShows, scrollType: 0) } }
        }
    }
}



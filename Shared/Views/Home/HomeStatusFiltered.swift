//
//  HomeStatusFiltered.swift
//  TV Show App
//
//  Created by AJ Glodowski on 2/3/23.
//

import SwiftUI

struct HomeStatusFiltered: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var vm = ShowsByStatusViewModel()
    
    var statuses: [Status] { modelData.statuses }
    
    @State var selectedStatus: Status? = nil
    
    var shows: [Show]? { vm.shows }
    
    var displayedShows: [Show] { shows ?? [] }
    
    func fetchShows() async {
        if (modelData.currentUser != nil) {
            await vm.loadShowsByStatus(userId: modelData.currentUser!.id, statusId: selectedStatus?.id, limit: 10)
        }
    }
    
    var body: some View {
        VStack {
            if (shows != nil) {
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
                            .tint(status == selectedStatus ? .blue : Color(.quaternaryLabel))
                            .buttonBorderShape(.capsule)
                        }
                    }
                }
                if (displayedShows.isEmpty) { Text("No shows with this status 😞") }
                else { VStack { SquareTileScrollRow(items: displayedShows, scrollType: ScrollRowType.NoExtraText) } }
            }
        }
        .task(id: modelData.currentUser) {
            await fetchShows()
        }
        .task(id: selectedStatus) {
            await fetchShows()
        }
    }
}



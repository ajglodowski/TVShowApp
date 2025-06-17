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
    
    var LinkDestination: some View {
        ShowSearch(
            searchType: ShowSearchType.watchlist,
            currentUserId: modelData.currentUser?.id,
            includeNavigation: false
        )
    }
    
    var isLoading: Bool { vm.isLoading }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: LinkDestination) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Image(systemName: "inset.filled.tv")
                            Text("Your Shows")
                                .font(.headline)
                        }
                        
                        Text("Select some statuses to filter your shows")
                            .font(.subheadline)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.white)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(statuses) { status in
                        Button(action: {
                            if (selectedStatus != status) { selectedStatus = status }
                            else { selectedStatus = nil }
                        }) {
                            Image(systemName: status.icon)
                            Text(status.name)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(status == selectedStatus ? .blue : Color(.quaternaryLabel))
                        .buttonBorderShape(.capsule)
                    }
                }
            }
            if (isLoading) {
                SquareTileScrollRowLoading()
            } else if (!displayedShows.isEmpty) {
                SquareTileScrollRow(items: displayedShows, scrollType: ScrollRowType.NoExtraText)
            } else {
                Text("No shows with this status 😞")
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

#Preview {
    HomeStatusFiltered()
        .environmentObject(ModelData())
}



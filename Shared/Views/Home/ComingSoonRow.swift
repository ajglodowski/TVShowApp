//
//  ComingSoonRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/16/24.
//

import SwiftUI

struct ComingSoonRow: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var vm = ShowsByStatusViewModel()
    
    var shows: [Show] { vm.shows ?? [] }
    
    var comingSoon: [Show] {
        shows
            .filter { $0.releaseDate != nil }
            .sorted { $0.releaseDate! < $1.releaseDate! }
    }
    
    var isLoading: Bool { vm.isLoading }
    
    var LinkDestination: some View {
        var filters = ShowFilters()
        let ComingSoonStatus = Status(id: ComingSoonStatusId, name: "Coming soon", created_at: Date(), update_at: Date())
        filters.userStatuses = [ComingSoonStatus]
        return ShowSearch(
            searchType: ShowSearchType.watchlist,
            currentUserId: modelData.currentUser?.id,
            initialFilters: filters,
            includeNavigation: false
        )
    }
    
    var body: some View {
        VStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: LinkDestination) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Image(systemName: "calendar.badge.clock")
                                    Text("Coming Soon")
                                        .font(.headline)
                                }
                                Text("Watch for these to come out soon!")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.horizontal, 2)
                        .foregroundStyle(.white)
                    }
                    if (isLoading) {
                        SquareTileScrollRowLoading()
                    } else {
                        SquareTileScrollRow(items: comingSoon, scrollType: ScrollRowType.ComingSoon)
                    }
                    
                }
                Divider()
            //AddToComingSoon()
        }
        .task(id: modelData.currentUser) {
            if (modelData.currentUser != nil) {
                await vm.loadShowsByStatus(userId: modelData.currentUser!.id, statusId: ComingSoonStatusId)
            }
        }
    }
}

#Preview {
    ComingSoonRow()
        .environmentObject(ModelData())
}

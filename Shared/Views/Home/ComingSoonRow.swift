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
    
    var body: some View {
        VStack {
            if (!comingSoon.isEmpty) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Coming Soon")
                            .font(.title)
                        Text("Watch for these to come out soon!")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 2)
                    SquareTileScrollRow(items: comingSoon, scrollType: ScrollRowType.ComingSoon)
                    
                }
                Divider()
            }
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
}

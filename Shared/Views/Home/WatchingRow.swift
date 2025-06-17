//
//  WatchingRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 11/11/23.
//

import SwiftUI

struct WatchingRow: View {
    
    var shows: [Show]
    
    var displayedStatusIds: [Int] = [
        CurrentlyAiringStatusId, NewReleaseStatusId, NewSeasonStatusId, CatchingUpStatusId
    ]
    
    var shownShows: [Show] {
        shows.filter { $0.userSpecificValues != nil && displayedStatusIds.contains($0.userSpecificValues!.status.id) }
            .sorted { $0.userSpecificValues!.lastUpdateDate ?? Date.distantPast > $1.userSpecificValues!.lastUpdateDate ?? Date.distantPast}
    }
    
    var body: some View {
        SquareTileScrollRow(items: shownShows, scrollType: ScrollRowType.StatusDisplayed)
    }
}

#Preview {
    var show1 = SampleShow
    show1.userSpecificValues?.status = MockStatus
    var previewShows = [show1]
    return WatchingRow(shows: previewShows)
}

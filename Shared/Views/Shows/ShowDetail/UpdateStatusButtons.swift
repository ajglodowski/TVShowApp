//
//  UpdateStatusButtons.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/6/22.
//

import SwiftUI
import Firebase

struct UpdateStatusButtons: View {
    
    func getStatusOptions(curStatus: Status) -> [Status] {
        switch curStatus {
        case Status.NeedsWatched:
            return [Status.CurrentlyAiring, Status.NewRelease, Status.CatchingUp]
        case Status.CurrentlyAiring, Status.NewSeason, Status.NewRelease:
            return [Status.UpToDate,Status.ShowEnded]
        case Status.UpToDate:
            return [Status.CurrentlyAiring,Status.ComingSoon,Status.NewSeason]
        default:
            return [Status]()
        }
    }
    
    var show: Show
    
    var body: some View {
        VStack {
            HStack {
                if (show.status != nil) {
                    ForEach(getStatusOptions(curStatus: show.status!)) { statusOption in
                        Button(action: {
                            if (statusOption == Status.CurrentlyAiring) {
                                updateShowCurrentlyAiring(currentlyAiringCurrentValue: false, showId: show.id)
                            }
                            updateShowStatus(showId: show.id, status: statusOption)
                        }) {
                            Text(statusOption.rawValue)
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    Button(action: {
                        var addingShow = show
                        addingShow.status = Status.NeedsWatched
                        addingShow.currentSeason = 1
                        addOrUpdateToUserShows(show: addingShow)
                        incrementShowCount(userId: Auth.auth().currentUser!.uid)
                    }) {
                        Text("Add to Watchlist")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

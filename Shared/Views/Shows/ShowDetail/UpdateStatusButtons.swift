//
//  UpdateStatusButtons.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/6/22.
//

import SwiftUI
import Firebase

struct UpdateStatusButtons: View {
    
    @State var showingAllStatus = false
    
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
        VStack(alignment: .leading) {
            if (!show.addedToUserShows) { AddToWatchlistButton }
            else {
                ScrollView(.horizontal) {
                    HStack(alignment:.top) {
                        if (!showingAllStatus) {
                            ForEach(getStatusOptions(curStatus: show.userSpecificValues!.status)) { statusOption in
                                Button(action: {
                                    changeShowStatus(show: show, status: statusOption)
                                }) {
                                    Text(statusOption.rawValue)
                                }
                                .buttonStyle(.bordered)
                            }
                        } else {
                            ForEach(Status.allCases) { statusOption in
                                VStack {
                                    Button(action: {
                                        changeShowStatus(show: show, status: statusOption)
                                    }) {
                                        Text(statusOption.rawValue)
                                    }
                                    .buttonStyle(.bordered)
                                    if (statusOption == show.userSpecificValues!.status) {
                                        Text("Current Status")
                                    }
                                }
                            }
                        }
                    }
                }
                VStack(alignment: .leading) {
                    if (!showingAllStatus) {
                        Button(action: {
                            showingAllStatus = true
                        }) {
                            Text("Show all Status Options")
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button(action: {
                            showingAllStatus = false
                        }) {
                            Text("Show only recomended Status Options")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
    
    var AddToWatchlistButton: some View {
        Button(action: {
            var addingShow = show
            let userSpecificValues = ShowUserSpecificValues(status: Status.NeedsWatched, currentSeason: 1)
            addingShow.userSpecificValues = userSpecificValues
            addUserUpdateWatchlist(userId: Auth.auth().currentUser!.uid, show: addingShow)
            addToUserShows(show: addingShow)
            incrementShowCount(userId: Auth.auth().currentUser!.uid)
        }) {
            Text("Add to Watchlist")
        }
        .buttonStyle(.bordered)
    }
}

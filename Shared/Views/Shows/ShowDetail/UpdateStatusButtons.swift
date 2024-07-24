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
    @EnvironmentObject var modelData : ModelData
    
    var uid: String { modelData.currentUser!.id }
    
    var statuses: [Status] { modelData.statuses }
    
    func getStatusOptions(curStatus: Status) -> [Status] {
        var statusIds: [Int] = []
        switch curStatus.id {
        case NeedsWatchedStatusId:
            statusIds = [CurrentlyAiringStatusId, NewReleaseStatusId, CatchingUpStatusId]
        case CurrentlyAiringStatusId, NewSeasonStatusId, NewReleaseStatusId:
            statusIds = [UpToDateStatusId,ShowEndedStatusId]
        case UpToDateStatusId:
            statusIds = [CurrentlyAiringStatusId,ComingSoonStatusId,NewSeasonStatusId]
        default:
            return [Status]()
        }
        return statuses.filter { statusIds.contains($0.id) }
    }
    
    var showId: Int
    var show: Show { modelData.showDict[showId]! }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (!show.addedToUserShows) { AddToWatchlistButton }
            else {
                ScrollView(.horizontal) {
                    HStack(alignment:.top) {
                        if (!showingAllStatus) {
                            ForEach(getStatusOptions(curStatus: show.userSpecificValues!.status)) { statusOption in
                                Button(action: {
                                    Task {
                                        let success = await updateUserShowData(updateType: UserUpdateCategory.UpdatedStatus, userId: uid, showId: show.id, seasonChange: nil, ratingChange: nil, statusChange: statusOption)
                                        if (success) {
                                            await modelData.reloadAllShowData(showId: show.id, userId: uid)
                                        }
                                    }
                                }) {
                                    Text(statusOption.name)
                                }
                                .buttonStyle(.bordered)
                            }
                        } else {
                            ForEach(statuses) { statusOption in
                                VStack {
                                    Button(action: {
                                        Task {
                                            let success = await updateUserShowData(updateType: UserUpdateCategory.UpdatedStatus, userId: uid, showId: show.id, seasonChange: nil, ratingChange: nil, statusChange: statusOption)
                                            if (success) {
                                                await modelData.reloadAllShowData(showId: show.id, userId: uid)
                                            }
                                        }
                                    }) {
                                        Text(statusOption.name)
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
            Task {
                let success = await updateUserShowData(updateType: UserUpdateCategory.AddedToWatchlist, userId: uid, showId: show.id, seasonChange: nil, ratingChange: nil, statusChange: nil)
                if (success) {
                    await modelData.reloadAllShowData(showId: show.id, userId: uid)
                }
            }
        }) {
            Text("Add to Watchlist")
        }
        .buttonStyle(.bordered)
    }
}

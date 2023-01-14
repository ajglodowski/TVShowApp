//
//  UpdateLogSection.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/2/23.
//

import SwiftUI
import Firebase

struct UpdateLogSection: View {
    
    var show: Show
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var updatesVm = ShowUpdatesViewModel()
    
    var userUpdates: [UserUpdate] { modelData.currentUserUpdates.filter { $0.showId == show.id } }
    var friendUpdates: [UserUpdate] {
        Array(modelData.updateDict.values).filter { $0.userId != Auth.auth().currentUser!.uid && $0.showId ==  show.id }
    }
    var friends: [String] { Array(Set(friendUpdates.map { $0.userId })) }
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                Text("Your updates for this show")
                    .font(.headline)
                UpdateLog(updates: userUpdates.sorted { $0.updateDate < $1.updateDate })
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(friends, id: \.self) { friend in
                        VStack (alignment: .leading) {
                            HStack(spacing: 0) {
                                ProfileBubble(profileId: friend)
                                Text("'s for this show")
                                    .font(.headline)
                            }
                            UpdateLog(updates: friendUpdates.filter { $0.userId == friend }.sorted { $0.updateDate < $1.updateDate })
                        }
                    }
                    
                }
            }
            
        }
        .task {
            if (modelData.currentUser != nil) {
                if (modelData.currentUser!.following != nil && !friendUpdates.isEmpty) {
                    updatesVm.loadUpdates(modelData: modelData, showId: show.id, friends: Array(modelData.currentUser!.following!.keys))
                }
                else { updatesVm.loadUpdates(modelData: modelData,showId: show.id, friends: []) }
            }
        }
    }
}

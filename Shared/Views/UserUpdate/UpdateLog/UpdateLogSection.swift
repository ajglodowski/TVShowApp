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
    
    @StateObject var updatesVm = ShowUpdatesViewModel()
    
    var userUpdates: [UserUpdate] { updatesVm.currentUserUpdates ?? [] }
    var friendUpdates: [UserUpdate] { updatesVm.friendUpdates ?? [] }
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
                                Text("'s updates for this show")
                                    .font(.headline)
                            }
                            UpdateLog(updates: friendUpdates.filter { $0.userId == friend }.sorted { $0.updateDate < $1.updateDate })
                        }
                    }
                    
                }
            }
            
        }
        .task {
            await updatesVm.loadUpdates(showId: show.id)
        }
    }
}

#Preview {
    let show = Show(from: MockSupabaseShow)
    return UpdateLogSection(show: show)
}

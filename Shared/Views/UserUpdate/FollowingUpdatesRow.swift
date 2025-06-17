//
//  FollowingUpdatesRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/2/23.
//

import SwiftUI

struct FollowingUpdatesRow: View {
    @EnvironmentObject var modelData : ModelData
    
    var updates: [UserUpdate] {
        modelData.lastFriendUpdates.sorted { $0.updateDate > $1.updateDate}
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your friend's most recent updates")
                .font(.title)
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    if (updates.isEmpty) {
                        ForEach(0..<5) { _ in
                            UserUpdateCardLoading()
                        }
                    } else {
                        ForEach (updates) { update in
                            NavigationLink(destination: ShowDetail(showId: update.showId)) {
                                UserUpdateCard(update: update)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        
    }
}

struct FollowingUpdatesRow_Previews: PreviewProvider {
    static var previews: some View {
        FollowingUpdatesRow()
            .environmentObject(ModelData())
    }
}

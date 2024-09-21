//
//  HomeUpdatesRows.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/11/24.
//

import SwiftUI

struct HomeUpdatesRows: View {
    
    @StateObject var updatesVm = RecentUpdatesViewModel()
    
    @EnvironmentObject var modelData: ModelData
    
    var curUserId: String { modelData.currentUser?.id ?? "1" }
    
    var currentUserUpdates: [UserUpdate] { updatesVm.currentUserUpdates ??  [] }
    
    var friendUpdates: [UserUpdate] { updatesVm.friendUpdates ?? [] }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Your friend's most recent updates")
                    .font(.title)
                UserUpdateRow(updates: friendUpdates)
            }
            Divider()
            NavigationLink(destination: AllUpdates(user: curUserId)) {
                VStack(alignment: .leading) {
                    Text("Your most recent updates")
                        .font(.title)
                        .foregroundColor(.white)
                    UserUpdateRow(updates: currentUserUpdates)
                }
            }
            Divider()
        }
        .task {
            await updatesVm.loadUpdates()
        }
    }
}

#Preview {
    HomeUpdatesRows()
}

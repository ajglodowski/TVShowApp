//
//  AllUpdates.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/9/23.
//

import SwiftUI

struct AllUpdates: View {
    
    let user: String
    
    @EnvironmentObject var modelData: ModelData
    let vm = ShowUpdatesViewModel()
    
    var displayedUpdates: [UserUpdate] {
        modelData.updateDict.values
            .filter { $0.userId == user }
            .sorted { $0.updateDate > $1.updateDate }
    }
    
    var body: some View {
        VStack {
            List {
                HStack {
                    ProfileTile(profileId: user)
                        .foregroundColor(.primary)
                    Text("'s Most Recent Updates")
                        .font(.title)
                }
                ForEach(displayedUpdates) { update in
                    NavigationLink(destination: ShowDetail(showId: update.showId)) {
                        UserUpdateDetailRow(update: update, userShown: false)
                    }
                }
            }
        }
        .task {
            //vm.loadMostRecent20Updates(modelData: modelData, userId:user)
        }
    }
}

struct AllUpdates_Previews: PreviewProvider {
    static var previews: some View {
        //AllUpdates()
        Text("Fix me")
    }
}

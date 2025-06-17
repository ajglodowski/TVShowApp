//
//  CurrentUserUpdatesRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/1/23.
//

import SwiftUI

struct CurrentUserUpdatesRow: View {
    
    @EnvironmentObject var modelData : ModelData

    var updates: [UserUpdate] {
        Array(modelData.currentUserUpdates.sorted { $0.updateDate > $1.updateDate}.prefix(10))
    }
    
    func getShowFromUpdate(update: UserUpdate) -> Show? {
        modelData.showDict[update.showId]
    }
    
    var body: some View {
        
        let curUserId = modelData.currentUser?.id ?? "1"
        
        NavigationLink(destination: AllUpdates(user: curUserId)) {
            VStack(alignment: .leading) {
                Text("Your most recent updates")
                    .font(.title)
                    .foregroundColor(.primary)
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        if (updates.isEmpty) {
                            ForEach (0..<5) { _ in
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
}

#Preview {
    return CurrentUserUpdatesRow()
        .environmentObject(ModelData())
}


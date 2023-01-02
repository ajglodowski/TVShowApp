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
        Array(modelData.currentUserUpdates.prefix(10)).sorted { $0.updateDate > $1.updateDate}
    }
    
    func getShowFromUpdate(update: UserUpdate) -> Show? {
        modelData.shows.first(where: { $0.id == update.showId})
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your most recent updates")
                .font(.title)
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach (updates) { update in
                        NavigationLink(destination: ShowDetail(showId: update.showId, show: getShowFromUpdate(update: update))) {
                            UserUpdateCard(update: update)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        
    }
}

struct CurrentUserUpdatesRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserUpdatesRow()
    }
}

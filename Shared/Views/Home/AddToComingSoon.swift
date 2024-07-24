//
//  AddToComingSoon.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/28/22.
//

import SwiftUI

struct AddToComingSoon: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var shows: [Show] {
        modelData.shows.filter({ $0.addedToUserShows })
    }
    
    var outOfSync: [Show] {
        shows.filter({ $0.userSpecificValues!.status.id != ComingSoonStatusId && $0.userSpecificValues!.status.id != SeenEnoughStatusId && $0.releaseDate != nil})
    }
    
    var body: some View {
        if (!outOfSync.isEmpty) {
            VStack(alignment: .leading) {
                Text("Add to Coming Soon")
                    .background()
                    .font(.title)
                Text("These shows have a release date but aren't in your coming soon")
                    .font(.subheadline)
                ScrollView (.horizontal) {
                    HStack {
                        ForEach(outOfSync) { s in
                            VStack {
                                //NavigationLink(destination: ShowDetail(showId: s.id, show: s)) {
                                NavigationLink(destination: ShowDetail(showId: s.id)) {
                                    ShowSquareTile(show: s, titleShown: true)
                                }
                                .foregroundColor(.primary)
                                Button(action:{
                                    //changeShowStatus(show: s, status: Status.ComingSoon)
                                }) {
                                    Text("Add to Coming Soon")
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                                Button(action:{
                                    //changeShowStatus(show: s, status: Status.SeenEnough)
                                }) {
                                    Text("Seen Enough")
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct AddToComingSoon_Previews: PreviewProvider {
    static var previews: some View {
        AddToComingSoon()
    }
}

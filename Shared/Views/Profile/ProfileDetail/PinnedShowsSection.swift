//
//  PinnedShowsSection.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/24/23.
//

import SwiftUI

struct PinnedShowsSection: View {
    
    var body: some View {
        Text("TODO")
    }
    
    /*
    @EnvironmentObject var modelData : ModelData
    
    var profile: Profile
    var currentProfile: Bool
    
    @State var editingPinnedShows: Bool = false
    
    @State var pinnedShowText: String = ""
    var pinnedShowSearchList: [Show] {
        modelData.shows.filter { $0.name.lowercased().contains(pinnedShowText.lowercased())}
    }
    
    var editToggleRow: some View {
        HStack {
            Text("\(profile.username)'s Pinned Shows:")
                .font(.headline)
            Spacer()
            if (currentProfile) {
                Button(action: {
                    editingPinnedShows.toggle()
                }) {
                    if (!editingPinnedShows) {
                        Text("Edit Pinned Shows")
                    } else {
                        Text("Stop Editing Pinned Shows")
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    var addMoreShowsSection: some View {
        VStack(alignment: .leading) {
            if (currentProfile && editingPinnedShows) {
                Text("Add more pinned shows")
                HStack { // Search Bar
                    Image(systemName: "magnifyingglass")
                    TextField("Search for a show here", text: $pinnedShowText)
                        .disableAutocorrection(true)
                    if (!pinnedShowText.isEmpty) {
                        Button(action: { pinnedShowText = "" }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
                ForEach(pinnedShowSearchList) { show in
                    Button(action: {
                        //pinShow(showId: show.id, showName: show.name)
                    }, label: {
                        Text(show.name)
                    })
                }
            }
        }
    }
    
    var pinnedShows: some View {
        VStack {
            if (profile.pinnedShows == nil || profile.pinnedShows!.isEmpty) {
                VStack {
                    Text("This user hasn't pinned any shows 😔")
                        .font(.headline)
                        .padding()
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(profile.pinnedShows!.sorted(by: >), id:\.key) { showId, showName in
                            VStack {
                                NavigationLink(destination: ShowDetail(showId: showId)) {
                                    ShowTile(showName: showName)
                                }
                                if (editingPinnedShows) {
                                    Button(action: {
                                        //unpinShow(showId: showId, showName: showName)
                                    }) {
                                        HStack {
                                            Text("Remove Pinned Show")
                                            Image(systemName: "xmark")
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                    .foregroundColor(Color.primary)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            editToggleRow
            
            pinnedShows
            
            addMoreShowsSection
            
        }
    }
     */
}

struct PinnedShowsSection_Previews: PreviewProvider {
    static var previews: some View {
        //PinnedShowsSection()
        Text("Fix me")
    }
}

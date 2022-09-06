//
//  DiscoverTab.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import SwiftUI

struct DiscoverTab: View {
    
    @ObservedObject var profileSearchVM = ProfileSearchViewModel()
    
    @State var profileSearchText = ""
    
    var body: some View {
        
        NavigationView {
            List {
                
                ZStack {
                    // Use for actual use
                    //let picShow = getRandPic(shows: unwatchedShows)
                    
                    // Use because picture fits well
                    let picShow = "Industry"
                    
                    Image(picShow)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(TextOverlay(text: "Discover New Shows"),alignment: .bottomLeading)
                        .shadow(color: .black, radius: 10)
                    NavigationLink(
                        destination: DiscoverList()) {
                            EmptyView()
                    }
                //.listRowInsets(EdgeInsets())
                }
                .ignoresSafeArea()
                
                userSearch
                
            }
            .listStyle(.plain)
            .navigationTitle("Discover")
        }
        .navigationViewStyle(.stack)
    }
    
    var userSearch: some View {
        VStack (alignment: .leading) {
            Text("Search for Users")
                .font(.title)
            Text("Unfortunately at this point you have to enter in the exact username 😔")
            HStack { // Search Bar
                Image(systemName: "magnifyingglass")
                TextField("Search for a user", text: $profileSearchText)
                    .onChange(of: profileSearchText) {
                        profileSearchVM.searchForUser(username: $0)
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                /*
                if (!profileSearchText.isEmpty) {
                    Button(action: {
                        profileSearchText = ""
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
                 */
                /*
                if (!profileSearchText.isEmpty) {
                    Button(action: {
                        profileSearchVM.searchForUser(username: profileSearchText)
                        print(profileSearchVM.profilesReturned)
                    }) {
                        Text("Search")
                    }
                    .buttonStyle(.bordered)
                }
                 */
            }
            .padding()
            VStack (alignment: .leading) {
                ForEach(profileSearchVM.profilesReturned, id:\.1) { profile in
                    HStack {
                        NavigationLink(destination: ProfileDetail(id: profile.1.id)) {
                            profile.0
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(profile.1.username)
                                    .font(.title)
                                    .bold()
                                Text("\(profile.1.showCount) shows logged")
                                    .italic()
                                Text("\(profile.1.followerCount) followers")
                            }
                        }
                    }
                }
            }
            //.listStyle(.automatic)
        }
    }
}


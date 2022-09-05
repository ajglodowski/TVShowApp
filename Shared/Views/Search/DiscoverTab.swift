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
                
                VStack {
                    Text("Search for Users")
                        .font(.title)
                    HStack { // Search Bar
                        Image(systemName: "magnifyingglass")
                        TextField("Search for a user", text: $profileSearchText)
                            .onChange(of: profileSearchText) {
                                profileSearchVM.searchForUser(username: $0)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.none)
                        if (!profileSearchText.isEmpty) {
                            Button(action: {
                                profileSearchVM.searchForUser(username: profileSearchText)
                                print(profileSearchVM.profilesReturned)
                            }) {
                                Text("Search")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding()
                    VStack (alignment: .leading) {
                        ForEach(profileSearchVM.profilesReturned, id:\.0) { profile in
                            NavigationLink(destination: ProfileDetail(id: profile.0)) {
                                Text(profile.1)
                            }
                        }
                    }
                    //.listStyle(.automatic)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Discover")
        }
        .navigationViewStyle(.stack)
    }
}


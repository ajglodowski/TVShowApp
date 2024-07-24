//
//  DiscoverTab.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import SwiftUI

struct DiscoverTab: View {
    
    @ObservedObject var profileSearchVM = ProfileSearchViewModel()
    
    @ObservedObject var popularShowsVm = PopularShowsViewModel()
    
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
                        destination: ShowSearch()) {
                            EmptyView()
                    }
                    
                //.listRowInsets(EdgeInsets())
                }
                .ignoresSafeArea()
                
                PopularShows()
                
                NewData()
             
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
                    ProfileTile(profileId: profile.1.id)
                }
            }
            //.listStyle(.automatic)
        }
    }
    
}

struct PopularShows: View {
    @ObservedObject var showsVm = PopularShowsViewModel()
    
    @EnvironmentObject var modelData : ModelData
    
    var body: some View {
        Text("TODO")
        /*
        var showDict = showsVm.totalMostPopularShows
        let shows = showDict
            
        VStack {
            ForEach(shows) { show in
                VStack{
                    Text(String(show.id))
                }
            }
        }
        .task {
            //showsVm.getPopularShowsFromAll(modelData: modelData)
        }
         */
    }
}


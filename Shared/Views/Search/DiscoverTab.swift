//
//  DiscoverTab.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import SwiftUI

struct DiscoverTab: View {
    
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
                        destination: SearchShows()) {
                            EmptyView()
                    }
                    
                //.listRowInsets(EdgeInsets())
                }
                .ignoresSafeArea()
                
                NavigationLink(destination: ActorList()) {
                    ZStack {
                        // Use for actual use
                        //let picShow = getRandPic(shows: unwatchedShows)
                        
                        // Use because picture fits well
                        let picShow = "Scenes from a Marriage"
                        
                        Image(picShow)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(TextOverlay(text: "Actors List"),alignment: .bottomLeading)
                            .shadow(color: .black, radius: 2)
                    }
                }
                .padding(.horizontal, 4)
                .padding(2)
                
                PopularShows()
                
                NewData()
             
                UserSearch()
                
            }
            .listStyle(.plain)
            .navigationTitle("Discover")
        }
        .navigationViewStyle(.stack)
    }
    
}

struct PopularShows: View {
    //@ObservedObject var showsVm = PopularShowsViewModel()
    
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


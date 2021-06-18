//
//  Home.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/2/21.
//

import SwiftUI

struct TextOverlay: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.white)
            .padding(20)
    }
    
}

struct Home: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var unwatchedShows: [Show] {
        modelData.shows.filter { show in
            !show.watched && show.status != "Currently Watching" && show.wanted && show.discovered
        }
    }
    
    var currentlyWatching: [Show] {
        modelData.shows.filter { show in
            show.status == "Currently Watching"
        }
    }
    
    var newSeasons: [Show] {
        modelData.shows.filter { show in
            show.status == "New Season"
        }
    }
    
    var undiscoveredShows: [Show] {
        modelData.shows.filter { show in
            !show.discovered
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ZStack {
                    
                    //var picShow = ModelData().shows[49].name
                    //print("!")
                    
                    let picShow = getRandPic(shows: unwatchedShows)
                    Image(picShow)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(TextOverlay(text: "Watchlist"),alignment: .bottomLeading)
                    VStack(alignment: .leading) {
                        
                    }
                    NavigationLink(
                        destination: WatchList()) {
                            EmptyView()
                    }
                //.listRowInsets(EdgeInsets())
                    
                }
                
                ScrollShowRow(items: newSeasons, scrollName: "New Seasons")
                
                ScrollShowRow(items: currentlyWatching, scrollName: "Currently Watching")
                
                VStack {
                    NavigationLink(destination: DiscoverPage()) {               Text("Discover Other Shows")
                        .font(.headline)
                        .padding(.top, 5)
                    }
                    SquareTileScrollRow(items: undiscoveredShows)
                }
                
                /*
                VStack {
                    Text("Discover")
                    SquareTileScrollRow(items: undiscoveredShows, scrollName: "Discover Something New")
                 */
                
                
                ScrollShowRow(items: unwatchedShows, scrollName: "Shows to Start")
                
            }
            .navigationTitle("Home")
        }
        .listRowInsets(EdgeInsets())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ModelData())
    }
}

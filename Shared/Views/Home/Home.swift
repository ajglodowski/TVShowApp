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
    
    // Used for adding show button
    @State private var isPresented = false
    @State private var newShow = Show(id:"1")
    
    var shows: [Show] {
        modelData.shows.filter { $0.status != nil }
    }
    
    var unwatchedShows: [Show] {
        shows.filter { $0.status! == Status.NeedsWatched }
        .sorted { $0.lastUpdateDate ?? Date(timeIntervalSince1970: 0) > $1.lastUpdateDate ?? Date(timeIntervalSince1970: 0) }
    }
    
    var currentlyWatching: [Show] {
        shows
            .filter { $0.status! == Status.CurrentlyAiring || $0.status! == Status.NewSeason || $0.status! == Status.CatchingUp }
            .sorted { $0.name < $1.name }
    }
    
    var comingSoon: [Show] {
        shows
            .filter { $0.status == Status.ComingSoon }
            .filter { $0.releaseDate != nil }
            .sorted { $0.releaseDate! < $1.releaseDate! }
    }
    
    var today: AirDate {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return AirDate.allCases.first(where: { $0.id+1 == weekday}) ?? AirDate.Other
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                NavigationLink(destination: WatchList()) {
                    ZStack {
                        // Use for actual use
                        //let picShow = getRandPic(shows: unwatchedShows)
                        
                        // Use because picture fits well
                        let picShow = "Handmaid's Tale"
                        
                        Image(picShow)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(TextOverlay(text: "Watchlist"),alignment: .bottomLeading)
                            .shadow(color: .black, radius: 2)
                    }
                }
                .padding(.horizontal, 4)
                .padding(2)
                
                //Divider()
                
                userSpecificRows
                
                HomeNewRows()
                
                //ScrollShowRow(items: currentlyWatching, scrollName: "Currently Watching")
                
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
                
                Divider()
                
                ComingSoonRows
                
                if (!unwatchedShows.isEmpty) {
                    VStack {
                        ScrollShowRow(items: unwatchedShows, scrollName: "Shows to Start")
                            
                    }
                    Divider()
                }
                
                bottomButtons
                
                outsidePages()
                
            }
            
            
            /*
            .refreshable {
                modelData.refreshData()
            }
             */
            
            
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    //ShowDetailEdit(isPresented: self.$isPresented, show: newShow, showIndex: shows.count-1)
                    ShowDetailEdit(isPresented: self.$isPresented, show: $newShow)
                        .navigationTitle(newShow.name)
                        .navigationBarItems(leading: Button("Cancel") {
                            isPresented = false
                        }, trailing: Button("Done") {
                            let newShowId = addToShows(show: newShow)
                            isPresented = false
                        })
                }
            }
            .navigationTitle("Home")
            
        }
        
        .listRowInsets(EdgeInsets())
        .navigationViewStyle(.stack)
        .listStyle(PlainListStyle())
    }
    
    var userSpecificRows: some View {
        VStack {
            
            FollowingUpdatesRow()
            
            Divider()
            
            CurrentUserUpdatesRow()
            
            Divider()
            
            if (!currentlyWatching.isEmpty) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Currently Watching")
                            .font(.title)
                        Text("Either currently airing, new season, or catching up")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 2)
                    SquareTileScrollRow(items: currentlyWatching, scrollType: 0)
                        
                }
                Divider()
            }
        }
    }
    
    
    var bottomButtons: some View {
        HStack (alignment: .center) {
            
            
            // Sync Button
            Button(action: {
                refreshAgolia()
            }, label: {
                Text("Sync Data")
                    //.font(.title)
            })
            .buttonStyle(.bordered)
             
             
            // Cache Button
            /*
            Button(action: {
                print(modelData.tileImageCache)
            }, label: {
                Text("View Cache")
                    //.font(.title)
            })
            .buttonStyle(.bordered)
            */
           
            // Reload Button
            Spacer()
            Button(action: {
                modelData.refreshData()
            }, label: {
                Text("Reload Data")
            })
            .buttonStyle(.bordered)
            
            Spacer()
            // New Show Button
            Button(action: {
                newShow = Show(id: "1")
                isPresented = true
            }, label: {
                Text("New Show")
                    //.font(.title)
            })
            .buttonStyle(.bordered)
        }
    }
    
    var ComingSoonRows: some View {
        VStack {
            if (!comingSoon.isEmpty) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Coming Soon")
                            .font(.title)
                        Text("Watch for these to come out soon!")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 2)
                    SquareTileScrollRow(items: comingSoon, scrollType: 2)
                    
                }
                Divider()
            }
            AddToComingSoon()
        }
    }
    
}

struct outsidePages: View {
    var body: some View {
        HStack {
            // Delete Page
            NavigationLink(
                destination: DeletePage(),
                label: {
                    Text("Delete Page")
                })
            .buttonStyle(PlainButtonStyle())
        }
        HStack {
            // Stats Page
            NavigationLink(
                destination: StatsPage(),
                label: {
                    Text("Stats Page")
                })
            .buttonStyle(PlainButtonStyle())
        }
        
        HStack {
            // Actor Game
            NavigationLink(
                destination: ActorReferenceGame(),
                label: {
                    Text("Actor Game")
                })
            .buttonStyle(PlainButtonStyle())
        }
        
        
        
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ModelData())
    }
}

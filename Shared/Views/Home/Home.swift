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
            List {
                
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
                        .shadow(color: .black, radius: 10)
                    NavigationLink(
                        destination: WatchList()) {
                            EmptyView()
                    }
                //.listRowInsets(EdgeInsets())
                }
                .ignoresSafeArea()
                
                HomeNewRows()
                
                //ScrollShowRow(items: currentlyWatching, scrollName: "Currently Watching")
                
                ZStack {
                    // Use because picture fits well
                    let picShow = "Scenes from a Marriage"
                    
                    Image(picShow)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(TextOverlay(text: "Actor List"),alignment: .bottomLeading)
                    NavigationLink(
                        destination: ActorList()) {
                            EmptyView()
                    }
                //.listRowInsets(EdgeInsets())
                    
                }
                .ignoresSafeArea()
                
                if (!currentlyWatching.isEmpty) {
                    VStack(alignment: .leading) {
                        Text("Currently Watching")
                            .font(.title)
                        Text("Either currently airing, new season, or catching up")
                            .font(.subheadline)
                        SquareTileScrollRow(items: currentlyWatching, scrollType: 0)
                    }
                    .ignoresSafeArea()
                }
                
                if (!comingSoon.isEmpty) {
                    VStack(alignment: .leading) {
                        Text("Coming Soon")
                            .font(.title)
                        Text("Watch for these to come out soon!")
                            .font(.subheadline)
                        SquareTileScrollRow(items: comingSoon, scrollType: 2)
                    }
                    .ignoresSafeArea()
                }
                
                AddToComingSoon()
                
                if (!unwatchedShows.isEmpty) {
                    VStack {
                        ScrollShowRow(items: unwatchedShows, scrollName: "Shows to Start")
                            .ignoresSafeArea()
                    }
                }
                
                HStack (alignment: .center) {
                    
                    /*
                    // Sync Button
                    Button(action: {
                        //modelData.saveData()
                        syncRatingCounts(showList: modelData.shows)
                    }, label: {
                        Text("Sync Data")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                     */
                     
                    // Cache Button
                    Button(action: {
                        print(modelData.tileImageCache)
                    }, label: {
                        Text("View Cache")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                    
                   
                    // Reload Button
                    Spacer()
                    Button(action: {
                        modelData.refreshData()
                        //print(modelData.actors)
                        //print(shows)
                    }, label: {
                        Text("Reload Data")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    // New Show Button
                    Button(action: {
                        // TODO
                        newShow = Show(id: "1")
                        //newShow = new
                        //modelData.shows.append(new)
                        isPresented = true
                        //shows.append(new)
                    }, label: {
                        Text("New Show")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                }
                
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
                            addToShows(show: newShow)
                            isPresented = false
                        })
                }
            }
            .navigationTitle("Home")
            //.ignoresSafeArea()
        }
        
        //.listRowInsets(EdgeInsets())
        .navigationViewStyle(.stack)
        .listStyle(PlainListStyle())
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

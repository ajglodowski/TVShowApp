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
    
    var unwatchedShows: [Show] {
        modelData.shows.filter { $0.status == Status.NeedsWatched && $0.discovered }
    }
    
    var currentlyWatching: [Show] {
        modelData.shows
            .filter { $0.status == Status.CurrentlyAiring || $0.status == Status.NewSeason || $0.status == Status.CatchingUp }
            .sorted { $0.name < $1.name }
    }
    
    var undiscoveredShows: [Show] {
        modelData.shows
            .filter { !$0.discovered }
    }
    
    var comingSoon: [Show] {
        modelData.shows
            .filter { $0.status == Status.ComingSoon }
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
                
                VStack(alignment: .leading) {
                    Text("Currently Watching")
                        .font(.title)
                    Text("Either currently airing, new season, or catching up")
                        .font(.subheadline)
                    SquareTileScrollRow(items: currentlyWatching, scrollType: 0)
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Coming Soon")
                        .font(.title)
                    Text("Watch for these to come out soon!")
                        .font(.subheadline)
                    SquareTileScrollRow(items: comingSoon, scrollType: 2)
                }
                .ignoresSafeArea()
                
                /*
                VStack {
                    NavigationLink(destination: DiscoverPage()) {               Text("Discover Other Shows")
                        .font(.title)
                        .padding(.top, 5)
                    }
                    SquareTileScrollRow(items: undiscoveredShows, scrollType: 0)
                }
                .ignoresSafeArea()
                 */
                 
                
                
                ScrollShowRow(items: unwatchedShows, scrollName: "Shows to Start")
                    .ignoresSafeArea()
                
                HStack (alignment: .center) {
                    // Save Button
                    Button(action: {
                        modelData.saveData()
                    }, label: {
                        Text("Save Data")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                   
                    // Reload Button
                    Spacer()
                    Button(action: {
                        modelData.refreshData()
                        print(modelData.actors)
                        print(modelData.shows)
                    }, label: {
                        Text("Reload Data")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                    
                    // Notification Button
                    Spacer()
                    Button(action: {
                        requestAuth()
                        pushNotfication(shows: modelData.shows)
                    }, label: {
                        Text("Enable Notifications")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    // New Show Button
                    Button(action: {
                        // TODO
                        let new = Show()
                        //newShow = new
                        modelData.shows.append(new)
                        isPresented = true
                        //modelData.shows.append(new)
                    }, label: {
                        Text("New Show")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                }
                
                outsidePages()
                
            }
            .refreshable {
                modelData.refreshData()
            }
            
            
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    let newShow = Show()
                    ShowDetailEdit(isPresented: self.$isPresented, show: newShow, showIndex: modelData.shows.count-1)
                        .navigationTitle(newShow.name)
                        .navigationBarItems(trailing: Button("Done") {
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
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ModelData())
    }
}

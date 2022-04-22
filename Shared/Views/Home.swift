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
    
    var currentlyAiring: [Show] {
        modelData.shows
            .filter { $0.status == Status.CurrentlyAiring }
            .sorted { $0.airdate.id < $1.airdate.id }
    }
    
    var newSeasons: [Show] {
        modelData.shows
            .filter { $0.status == Status.NewSeason }
            .sorted { $0.name < $1.name }
    }
    
    var undiscoveredShows: [Show] {
        modelData.shows
            .filter { !$0.discovered }
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
                
                VStack(alignment: .leading) {
                    Text("Currently Airing")
                        .font(.title)
                    SquareTileScrollRow(items: currentlyAiring, scrollType: 1)
                }
                
                ScrollShowRow(items: newSeasons, scrollName: "New Seasons")
                
                //ScrollShowRow(items: currentlyWatching, scrollName: "Currently Watching")
                
                VStack(alignment: .leading) {
                    Text("Currently Watching")
                        .font(.title)
                    SquareTileScrollRow(items: currentlyWatching, scrollType: 0)
                }
                
                VStack {
                    NavigationLink(destination: DiscoverPage()) {               Text("Discover Other Shows")
                        .font(.title)
                        .padding(.top, 5)
                    }
                    SquareTileScrollRow(items: undiscoveredShows, scrollType: 0)
                }
                
                /*
                VStack {
                    Text("Discover")
                    SquareTileScrollRow(items: undiscoveredShows, scrollName: "Discover Something New")
                 */
                
                
                ScrollShowRow(items: unwatchedShows, scrollName: "Shows to Start")
                
                HStack (alignment: .center) {
                    // Save Button
                    Button(action: {
                        modelData.saveToJsonFile()
                    }, label: {
                        Text("Save Data")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
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
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                
                HStack {
                    // Delete Page
                    NavigationLink(
                        destination: DeletePage(),
                        label: {
                            Text("Delete Page")
                        })
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .navigationTitle("Home")
            
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    let newShow = Show()
                    ShowDetailEdit(isPresented: self.$isPresented, show: newShow)
                        .navigationTitle(newShow.name)
                        .navigationBarItems(trailing: Button("Done") {
                            isPresented = false
                        })
                }
            }
            .ignoresSafeArea()
        }
        //.listRowInsets(EdgeInsets())
        .navigationViewStyle(.stack)
        .listStyle(PlainListStyle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ModelData())
    }
}

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
    @State private var newShow = Show(id:1)
    
    var shows: [Show] {
        modelData.shows.filter { $0.addedToUserShows }
    }
    
    var unwatchedShows: [Show] {
        shows.filter { $0.userSpecificValues!.status.id == NeedsWatchedStatusId }
            .sorted { $0.userSpecificValues!.updated > $1.userSpecificValues!.updated }
    }
    
    var currentlyWatching: [Show] {
        shows
            .filter { $0.userSpecificValues!.status.id == CurrentlyAiringStatusId || $0.userSpecificValues!.status.id == NewSeasonStatusId || $0.userSpecificValues!.status.id == CatchingUpStatusId }
            .sorted { $0.name < $1.name }
    }
    
    var comingSoon: [Show] {
        shows
            .filter { $0.userSpecificValues!.status.id == ComingSoonStatusId }
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
                
                HomeUpdatesRows()
                
                HomeStatusFiltered()
                
                CurrentlyAiringRow()
                
                //HomeNewRows()
                
                //ScrollShowRow(items: currentlyWatching, scrollName: "Currently Watching")
                
                
                
                Divider()
                
                ComingSoonRow()
                
                if (!unwatchedShows.isEmpty) {
                    VStack {
                        ScrollShowRow(items: unwatchedShows, scrollName: "Shows to Start")
                            
                    }
                    Divider()
                }
                
                //bottomButtons
                
                outsidePages()
                
            }
            
        
            
            .refreshable {
                Task {
                    await modelData.loadEverything()
                }
            }
             
            
            
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    //ShowDetailEdit(isPresented: self.$isPresented, show: newShow, showIndex: shows.count-1)
                    ShowDetailEdit(isPresented: self.$isPresented, show: $newShow)
                        .navigationTitle(newShow.name)
                        .navigationBarItems(leading: Button("Cancel") {
                            isPresented = false
                        }, trailing: Button("Done") {
                            //let _ = addToShows(show: newShow)
                            isPresented = false
                        })
                }
            }
            .navigationTitle("Home")
            .toolbar {
                NavigationLink(destination: CurrentUserProfileDetail()) {
                    Image(systemName: "person.fill")
                }
            }
            
        }
        .listRowInsets(EdgeInsets())
        .navigationViewStyle(.stack)
        .listStyle(PlainListStyle())
    }
    
    
    var bottomButtons: some View {
        HStack (alignment: .center) {
            
            
            // Sync Button
            Button(action: {
                //updateUserInfoDates()
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
                Task {
                    await modelData.loadEverything()
                }
            }, label: {
                Text("Reload Data")
            })
            .buttonStyle(.bordered)
            
            Spacer()
            // New Show Button
            Button(action: {
                newShow = Show(id: 1)
                isPresented = true
            }, label: {
                Text("New Show")
                    //.font(.title)
            })
            .buttonStyle(.bordered)
        }
    }
    
}

struct outsidePages: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var body: some View {
        HStack {
//            HStack {
//                // Delete Page
//                NavigationLink(
//                    destination: DeletePage(),
//                    label: {
//                        Text("Delete Page")
//                    })
//                .buttonStyle(.bordered)
//            }
            HStack {
                // Stats Page
                NavigationLink(
                    destination: StatsPage(),
                    label: {
                        Text("Stats Page")
                    })
                .buttonStyle(.bordered)
            }
            
            HStack {
                // Actor Game
                NavigationLink(
                    destination: ActorReferenceGame(),
                    label: {
                        Text("Actor Game")
                    })
                .buttonStyle(.bordered)
            }
        }
        
        
        
    }
}

#Preview {
    return Home()
        .environmentObject(ModelData())
}

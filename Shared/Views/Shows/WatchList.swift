//
//  WatchList.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine

struct WatchList: View {
    @EnvironmentObject var modelData : ModelData
    //var shows : ModelData().shows
    
    @State private var showUnwatchedOnly = false
    @State private var showRunningOnly = false
    
    @State private var showServiceFilterOnly = false
    
    @State private var searchText = ""
    
    
    var unwatchedShows: [Show] {
        ModelData().shows.filter { show in
            !show.watched
        }
    }
    
    var runningShows: [Show] {
        ModelData().shows.filter { show in
            show.running
        }
    }
    
    var runningUnwatchedShows: [Show] {
        unwatchedShows.filter { show in
            show.running
        }
    }
    
    var searchShows: [Show] {
        ModelData().shows.filter { show in
            show.name.contains(searchText)
        }
    }
    
    @State var serviceFilteredShows = [Show]()
    @State var appliedFilters = [Service]()
    
    
    var body: some View {
        
        List {
            
            
        
            HStack { // Search Bar
                Image(systemName: "magnifyingglass")
                TextField("Search for show here", text: $searchText)
                if (!searchText.isEmpty) {
                    Button(action: {searchText = ""}, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(20)
                //.padding(.horizontal)
            
            if (searchText.isEmpty) {
                
                HStack {
                    
                    Toggle(isOn: $showUnwatchedOnly) {
                        Text("Show Watchlist")
                    }
                    Toggle(isOn: $showRunningOnly) {
                        Text("Show Currently Running")
                    }
                    
                    Menu {
                        
                        ForEach(Service.allCases) { service in
                            Button(action: {
                                serviceFilteredShows = applyFilter(applied: appliedFilters, shows: serviceFilteredShows, serivce: service)
                                if (appliedFilters.contains(service)) {
                                    appliedFilters = appliedFilters.filter { $0 != service}
                                } else {
                                    appliedFilters.append(service)
                                }
                            }) {
                                Label(service.rawValue, systemImage: appliedFilters.contains(service) ?
                                        "checkmark" : "")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                }
                
                
                HStack {
                    Text("Show Title")
                    Spacer()
                    
                    Text("Watched?")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Divider()
                    Text("Running?")
                    
                }
                
                
                
                /*
                if (showRunningOnly && showUnwatchedOnly) {
                    ForEach(runningUnwatchedShows) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                        ListShowRow(show: show)
                        }
                    }
                } else if (showRunningOnly) {
                    ForEach(runningShows) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                        ListShowRow(show: show)
                        }
                    }
                } else if (showUnwatchedOnly) {
                    ForEach(unwatchedShows) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ListShowRow(show: show)
                        }
                    }
                } else {
                    ForEach(ModelData().shows) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ListShowRow(show: show)
                        }
                    }
                }
                */
                
                if (serviceFilteredShows.count > 0) {
                    ForEach(serviceFilteredShows) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ListShowRow(show: show)
                        }
                    }
                } else {
                    ForEach(ModelData().shows) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ListShowRow(show: show)
                        }
                    }
                }
                
            } else {
                ForEach(searchShows) { show in
                    NavigationLink(destination: ShowDetail(show: show)) {
                        ListShowRow(show: show)
                    }
                }
            }
            
            
        }
        .navigationTitle("Watchlist")
    }
}

struct WatchList_Previews: PreviewProvider {
    
    //.environmentObject(UserData())
    
    static var previews: some View {
        WatchList()
            .environmentObject(ModelData())
    }
}

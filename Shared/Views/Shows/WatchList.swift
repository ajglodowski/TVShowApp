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
    
    @State private var searchText = ""
    
    var searchShows: [Show] {
        modelData.shows.filter { show in
            show.name.contains(searchText)
        }
    }
    
    var displayedShows : [Show] {
        /*
        if (searchText != "") {
            return searchShows
        } else {
            return applyAllFilters(serviceFilters: appliedServiceFilters, showLengthFilter: selectedLength)
        }
         */
        return applyAllFilters(serviceFilters: appliedServiceFilters, showLengthFilter: selectedLength, shows: modelData.shows)
    }
    
    @State var appliedServiceFilters = [Service]()
    @State var selectedLength: ShowLength = ShowLength.min
    
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
                    
                    
                    
                    VStack {
                        Text("Length").bold()
                        Picker("Length", selection: $selectedLength) {
                            ForEach(ShowLength.allCases) { length in
                                Text(length.rawValue).tag(length)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    
                    Menu {
                        ForEach(Service.allCases) { service in
                            Button(action: {
                                
                                if (appliedServiceFilters.contains(service)) {
                                    appliedServiceFilters = appliedServiceFilters.filter { $0 != service}
                                } else {
                                    appliedServiceFilters.append(service)
                                }
                            }) {
                                Label(service.rawValue, systemImage: appliedServiceFilters.contains(service) ?
                                        "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            
                    }
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaledToFill()
                    
                }
                
                if (!appliedServiceFilters.isEmpty) {
                    HStack {
                        ForEach(appliedServiceFilters) { service in
                        
                            // Bug in removing service functionality
                            Button(service.rawValue, action: {
                                appliedServiceFilters = appliedServiceFilters.filter { $0 != service}
                            })
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.blue.opacity(0.80).cornerRadius(8))
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                
                HStack {
                    Text("Show Title")
                    Spacer()
                    
                    Text("Watched?")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Divider()
                    Text("Running?")
                    
                }
                
                
                ForEach(displayedShows) { show in
                    NavigationLink(destination: ShowDetail(show: show)) {
                        ListShowRow(show: show)
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

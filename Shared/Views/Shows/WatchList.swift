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
        applyAllFilters(serviceFilters: appliedServiceFilters, statusFilters: appliedStatusFilters, showLengthFilter: selectedLength, shows: modelData.shows)
            .sorted { $0.name < $1.name }
    }
    
    @State var appliedServiceFilters = [Service]()
    @State var appliedStatusFilters = [Status]()
    @State var selectedLength: ShowLength = ShowLength.min
    
    var body: some View {
        
        List {
            /*
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
            //.background(Color(.systemGray5))
            //.cornerRadius(20)
                //.padding(.horizontal)
             */
            
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
                    
                    VStack {
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
                            Text("Filter by Service")
                            //Image(systemName: "slider.horizontal.3")
                        }
                        //.scaledToFill()
                        //.frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        
                        Menu {
                            ForEach(Status.allCases) { status in
                                Button(action: {
                                    if (appliedStatusFilters.contains(status)) {
                                        appliedStatusFilters = appliedStatusFilters.filter { $0 != status}
                                    } else {
                                        appliedStatusFilters.append(status)
                                    }
                                }) {
                                    Label(status.rawValue, systemImage: appliedStatusFilters.contains(status) ?
                                            "checkmark" : "")
                                }
                            }
                        } label: {
                            Text("Filter by Status")
                        }
                        //.scaledToFill()
                        //.frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
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
                .onDelete(perform: removeRows)
                 
            } else {
                ForEach(searchShows) { show in
                    NavigationLink(destination: ShowDetail(show: show)) {
                        ListShowRow(show: show)
                    }
                }
            }
            
            
        }
        .navigationTitle("Watchlist")
        .searchable(text: $searchText)
    }
    
    func removeRows(at offsets: IndexSet) {
        ModelData().shows.remove(atOffsets: offsets)
    }
    
}



struct WatchList_Previews: PreviewProvider {
    
    //.environmentObject(UserData())
    
    static var previews: some View {
        WatchList()
            .environmentObject(ModelData())
    }
}

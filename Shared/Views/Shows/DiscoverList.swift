//
//  WatchList.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine

struct DiscoverList: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @State private var searchText = ""
    
    var shows: [Show] {
        modelData.shows.filter { !$0.addedToUserShows }
    }
    
    var searchShows: [Show] {
        shows.filter { show in
            show.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var displayedShows : [Show] {
        var out = applyAllFilters(serviceFilters: appliedServiceFilters, statusFilters: nil, ratingFilters: [], tagFilters: appliedTagFilters, showLengthFilter: selectedLength, shows: shows, selectedLimited: selectedLimited, selectedRunning: selectedRunning, selectedAiring: selectedAiring)
            .sorted { $0.name < $1.name }
        
        if (selectedAvgRating != 0) {
            out = out.filter { !$0.avgRating.isNaN }
            if (selectedAvgRating == 1) {
                out = out.sorted { $0.avgRating > $1.avgRating }
            } else if (selectedAvgRating == 2) {
                out = out.sorted { $0.avgRating < $1.avgRating }
            }
        }
        
        return out
    }
    
    @State var appliedServiceFilters = [Service]()
    @State var appliedTagFilters = [Tag]()
    @State var selectedLength: ShowLength = ShowLength.none
    @State var selectedAvgRating: Int = 0
    
    @State var selectedLimited: Int = 0
    @State var selectedRunning: Int = 0
    @State var selectedAiring: Int = 0
    
    @State var selectedCategories = [TagCategory]()
    var filteredTags: [Tag] {
        if (!selectedCategories.isEmpty) {
            var tags = [Tag]()
            for cat in selectedCategories {
                tags.append(contentsOf: Tag.allCases.filter { $0.category == cat})
            }
            return tags
        } else {
            return Tag.allCases
        }
    }
    
    
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
                
                toolBar
                
                appliedFilterButtons
                
                HStack {
                    Text("Show Title")
                    Spacer()
                    Text("Running?")
                }
                
                ForEach(displayedShows) { show in
                    NavigationLink(destination: ShowDetail(showId: show.id)) {
                        ListShowRow(show: show)
                    }
                }
                //.onDelete(perform: removeRows)
                 
            } else {
                ForEach(searchShows) { show in
                    NavigationLink(destination: ShowDetail(showId: show.id)) {
                        ListShowRow(show: show)
                    }
                }
            }
            
            
        }
        .navigationTitle("Discover other shows")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .disableAutocorrection(true)
    }
    
    var toolBar: some View {
        
        VStack {
            HStack { // Length Row
                VStack {
                    Text("Length").bold()
                    Picker("Length", selection: $selectedLength) {
                        ForEach(ShowLength.allCases) { length in
                            Text(length.rawValue).tag(length)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            HStack { // Filter Row
                Menu { // Service Filter
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
                    Image(systemName: "slider.horizontal.3")
                    Text("Service")
                }
                .padding(5)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)

                
                Menu { // Tag Filter
                    HStack {
                        Section {
                            ForEach(TagCategory.allCases) { category in
                                Button (action: {
                                    if (selectedCategories.contains(category)) {
                                        selectedCategories = selectedCategories.filter { $0 != category}
                                    } else {
                                        selectedCategories.append(category)
                                    }
                                }) {
                                    Label(category.rawValue, systemImage: selectedCategories.contains(category) ?
                                          "checkmark" : "")
                                }
                            }
                        }
                        Section {
                            ForEach(filteredTags) { tag in
                                Button(action: {
                                    if (appliedTagFilters.contains(tag)) {
                                        appliedTagFilters = appliedTagFilters.filter { $0 != tag}
                                    } else {
                                        appliedTagFilters.append(tag)
                                    }
                                }) {
                                    Label(tag.rawValue, systemImage: appliedTagFilters.contains(tag) ?
                                          "checkmark" : "")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "tag")
                }
                .padding(5)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                
                Picker("Limited Series?", selection: $selectedLimited) {
                    Text("All").tag(0)
                    Text("Non-Limited").tag(1)
                    Text("Limited").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                VStack {
                    Text("Sort by Average Rating")
                    Picker("Sort by Average Rating", selection: $selectedAvgRating) {
                        Text("None").tag(0)
                        Text("Highest").tag(1)
                        Text("Lowest").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
            }
        }
    }
    
    var appliedFilterButtons: some View {
        VStack {
            if (!appliedServiceFilters.isEmpty) {
                HStack {
                    ForEach(appliedServiceFilters) { service in
                    
                        // Bug in removing service functionality
                        Button(action: {
                            appliedServiceFilters = appliedServiceFilters.filter { $0 != service}
                        }, label: {
                            HStack {
                                Text(service.rawValue)
                                Image(systemName: "xmark")
                            }
                
                        })
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
            
            if (!appliedTagFilters.isEmpty) {
                HStack {
                    ForEach(appliedTagFilters) { tag in
                        Button(action: {
                            appliedTagFilters = appliedTagFilters.filter { $0 != tag}
                        }, label: {
                            HStack {
                                Text(tag.rawValue)
                                Image(systemName: "xmark")
                            }
                
                        })
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
        }
    }
    
    /*
    func removeRows(at offsets: IndexSet) {
        ModelData().shows.remove(atOffsets: offsets)
    }
     */
    
}



struct DiscoverList_Previews: PreviewProvider {
    
    //.environmentObject(UserData())
    
    static var previews: some View {
        DiscoverList()
            .environmentObject(ModelData())
    }
}

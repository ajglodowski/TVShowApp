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
    
    var shows: [Show] {
        modelData.shows.filter { $0.addedToUserShows }
    }
    
    var searchShows: [Show] {
        shows.filter { show in
            show.name.lowercased().contains(searchText.lowercased())
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
        var out = applyAllFilters(serviceFilters: appliedServiceFilters, statusFilters: appliedStatusFilters, ratingFilters: appliedRatingFilters, tagFilters: appliedTagFilters, showLengthFilter: selectedLength, shows: shows, selectedLimited: selectedLimited, selectedRunning: selectedRunning, selectedAiring: selectedAiring, appliedAirdateFilters: appliedAirdateFilters)
            .sorted { $0.name < $1.name }
        
        if (selectedRatingOrder != 0) {
            out = out.filter { !$0.avgRating.isNaN }
            if (selectedRatingCategory == 1) {
                if (selectedRatingOrder == 1) {
                    out = out.sorted { $0.avgRating > $1.avgRating }
                } else if (selectedRatingOrder == 2) {
                    out = out.sorted { $0.avgRating < $1.avgRating }
                }
            } else {
                if (selectedRatingOrder == 1) {
                    out = out.sorted { $0.userSpecificValues!.rating?.pointValue ?? 0 > $1.userSpecificValues!.rating?.pointValue ?? 0 }
                } else if (selectedRatingOrder == 2) {
                    out = out.sorted { $0.userSpecificValues!.rating?.pointValue ?? 0 < $1.userSpecificValues!.rating?.pointValue ?? 0 }
                }
            }
        }

        return out
        
    }
    
    @State var appliedServiceFilters = [Service]()
    @State var appliedStatusFilters = [Status]()
    @State var appliedRatingFilters = [Rating?]()
    @State var appliedAirdateFilters = [AirDate?]()
    @State var appliedTagFilters = [Tag]()
    @State var selectedLength: ShowLength = ShowLength.none
    @State var selectedRatingCategory: Int = 0
    @State var selectedRatingOrder: Int = 0
    
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
    
    @State var displayOptions: Bool = false
    
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
                    Toggle(isOn: $displayOptions, label: {
                        Text("Show options?")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                if (displayOptions) {
                    toolBar
                }
                
                if (!appliedServiceFilters.isEmpty || !appliedStatusFilters.isEmpty || !appliedRatingFilters.isEmpty || !appliedTagFilters.isEmpty) {
                    appliedFilterButtons
                }
                
                HStack {
                    Text("Show Title")
                    Spacer()
                    Text("Your Rating")
                }
                
                ForEach(displayedShows) { show in
                    //NavigationLink(destination: ShowDetail(showId: show.id, show: show)) {
                    NavigationLink(destination: ShowDetail(showId: show.id)) {
                        ListShowRow(show: show)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                //.onDelete(perform: removeRows)
                 
            } else {
                ForEach(searchShows) { show in
                    //NavigationLink(destination: ShowDetail(showId: show.id, show: show)) {
                    NavigationLink(destination: ShowDetail(showId: show.id)) {
                        ListShowRow(show: show)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            
        }
        .navigationTitle("Watchlist")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .disableAutocorrection(true)
    }
    
    var toolBar: some View {
        VStack {
            HStack { // Length Row
                VStack {
                    Text("Length")
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
                
                Menu { // Status Filter
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
                    Image(systemName: "slider.horizontal.3")
                    Text("Status")
                }
                .padding(5)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                
                Menu { // Airdate Filter
                    Button(action: {
                        if (appliedAirdateFilters.contains(nil)) {
                            appliedAirdateFilters = appliedAirdateFilters.filter { $0 != nil}
                        } else {
                            appliedAirdateFilters.append(nil)
                        }
                    }) {
                        Label("No Airdate", systemImage: appliedAirdateFilters.contains(nil) ?
                              "checkmark" : "")
                    }
                    ForEach(AirDate.allCases) { airdate in
                        Button(action: {
                            if (appliedAirdateFilters.contains(airdate)) {
                                appliedAirdateFilters = appliedAirdateFilters.filter { $0 != airdate}
                            } else {
                                appliedAirdateFilters.append(airdate)
                            }
                        }) {
                            Label(airdate.rawValue, systemImage: appliedAirdateFilters.contains(airdate) ?
                                  "checkmark" : "")
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                    Text("Airdate")
                }
                .padding(5)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                
                
            }
            
            // Sorting by rating
            HStack {
                
                HStack {
                    Menu { // Rating Filter
                        Button(action: {
                            if (appliedRatingFilters.contains(nil)) {
                                appliedRatingFilters = appliedRatingFilters.filter { $0 != nil}
                            } else {
                                appliedRatingFilters.append(nil)
                            }
                        }) {
                            Label("No Rating", systemImage: appliedRatingFilters.contains(nil) ?
                                  "checkmark" : "")
                        }
                        ForEach(Rating.allCases) { rating in
                            Button(action: {
                                if (appliedRatingFilters.contains(rating)) {
                                    appliedRatingFilters = appliedRatingFilters.filter { $0 != rating}
                                } else {
                                    appliedRatingFilters.append(rating)
                                }
                            }) {
                                Label(rating.rawValue, systemImage: appliedRatingFilters.contains(rating) ?
                                      "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                        Text("Rating")
                    }
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    
                    Divider()
                    
                    Menu { // Status Filter
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
                    
                }
                
                Divider()
                
                VStack {
                    Text("Sort By Rating")
                    Picker("Rating Sort Category", selection: $selectedRatingCategory) {
                        Text("My Rating").tag(0)
                        Text("Average Rating").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Picker("Sort by your rating", selection: $selectedRatingOrder) {
                        Text("None").tag(0)
                        Text("Highest").tag(1)
                        Text("Lowest").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            toggleRow
            
        }
    }
    
    var appliedFilterButtons: some View {
            VStack {
                
                if (!appliedServiceFilters.isEmpty) {
                    ScrollView (.horizontal) {
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
                }
                
                if (!appliedStatusFilters.isEmpty) {
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(appliedStatusFilters) { status in
                                
                                // Bug in removing service functionality
                                Button(action: {
                                    appliedStatusFilters = appliedStatusFilters.filter { $0 != status}
                                }, label: {
                                    HStack {
                                        Text(status.rawValue)
                                        Image(systemName: "xmark")
                                    }
                                    
                                })
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            }
                        }
                    }
                }
                
                if (!appliedRatingFilters.isEmpty) {
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(appliedRatingFilters, id:\.self) { rating in
                                Button(action: {
                                    appliedRatingFilters = appliedRatingFilters.filter { $0 != rating}
                                }, label: {
                                    HStack {
                                        Text(rating?.rawValue ?? "No Rating")
                                        Image(systemName: "xmark")
                                    }
                                    
                                })
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            }
                        }
                    }
                }
                
                if (!appliedTagFilters.isEmpty) {
                    ScrollView (.horizontal) {
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
    }
    
    var toggleRow: some View {
        HStack {
            Picker("Limited Series?", selection: $selectedLimited) {
                Text("All").tag(0)
                Text("Non-Limited").tag(1)
                Text("Limited").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Divider()
            
            Picker("Running?", selection: $selectedRunning) {
                Text("All").tag(0)
                Text("Running").tag(1)
                Text("Ended").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker("Airing?", selection: $selectedAiring) {
                Text("All").tag(0)
                Text("Airing").tag(1)
                Text("Not Airing").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
        }
    }
    
}



struct WatchList_Previews: PreviewProvider {
    
    //.environmentObject(UserData())
    
    static var previews: some View {
        WatchList()
            .environmentObject(ModelData())
    }
}

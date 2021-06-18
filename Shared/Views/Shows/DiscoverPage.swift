//
//  DiscoverPage.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import SwiftUI

struct DiscoverPage: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @State private var searchText = ""
    @State var selectedLength: ShowLength = ShowLength.min
    @State var appliedServiceFilters = [Service]()

    
    var undiscoveredShows: [Show] {
        ModelData().shows.filter { show in
            !show.discovered
        }
    }
    
    var searchShows: [Show] {
        undiscoveredShows.filter { show in
            show.name.contains(searchText)
        }
    }
    
    var displayedShows : [Show] {
        if (searchText != "") {
            return searchShows
        } else {
            return applyAllFilters(serviceFilters: appliedServiceFilters, showLengthFilter: selectedLength, shows: undiscoveredShows)
        }
    }
    
    
    var body: some View {
        
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
        
        
        Picker("Length", selection: $selectedLength) {
            ForEach(ShowLength.allCases) { length in
                Text(length.rawValue).tag(length)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        
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
        
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 150, maximum: 300), spacing: 12, alignment: .top),
                GridItem(.flexible(minimum: 150, maximum: 300), spacing: 12, alignment: .top)
            ], spacing: 12, content: {
                ForEach(displayedShows) { show in
                    NavigationLink(destination: ShowDetail(show: show)) {
                        ShowSquareTile(show: show)
                    }
                }
            })
        }
        
    }
}

struct DiscoverPage_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPage()
    }
}

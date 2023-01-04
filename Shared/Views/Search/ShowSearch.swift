//
//  ShowSearch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/3/23.
//

import SwiftUI
import InstantSearchSwiftUI
import InstantSearch

struct ShowSearch: View {
    
    static let algoliaController = AlgoliaController()
    @ObservedObject var searchBoxController: SearchBoxObservableController = algoliaController.searchBoxController
    @ObservedObject var hitsController: HitsObservableController<Hit<AlgoliaShow>> = algoliaController.hitsController
    
    var hits: [Show] {
        var output = [Show]()
        for hit in hitsController.hits {
            if (hit != nil) {
                let id = hit!.objectID.rawValue
                let obj = hit!.object
                var new = Show(id: id)
                new.name = obj.name
                new.service = obj.service
                new.running = obj.running
                new.tags = obj.tags
                new.totalSeasons = obj.totalSeasons
                new.limitedSeries = obj.limitedSeries
                new.length = obj.length
                new.releaseDate = obj.releaseDate
                new.airdate = obj.airdate
                output.append(new)
            }
        }
        return output
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            List {
                if (searchBoxController.query.isEmpty) {
                    VStack(alignment: .leading) {
                        Text("Use the search bar to find the show you're looking for")
                            .font(.headline)
                        Text("Try adding service or tags in your search if you're not sure what you're looking for")
                            .font(.subheadline)
                    }
                }
                
                ForEach(hits) { hit in
                    NavigationLink(destination: ShowDetail(showId: hit.id)) {
                        HStack {
                            Text(hit.name)
                        }
                    }
                    .foregroundColor(.primary)
                }
                /*
                HitsList(hitsController) { (hit, _) in
                    if (hit != nil) {
                        VStack(alignment: .leading) {
                            NavigationLink(destination: ShowDetail(showId: (hit?.objectID.rawValue)!)) {
                                HStack {
                                    Text(hit?.object.name ?? "")
                                }
                            }
                            .foregroundColor(.primary)
                            Divider()
                        }
                    }
                } noResults: {
                    Text("No Results")
                }
                 */
            }
        }
        .searchable(text: $searchBoxController.query, placement: .navigationBarDrawer(displayMode: .always))
        .disableAutocorrection(true)
        .navigationTitle("Find a Show")
        .listStyle(.plain)
    }

}

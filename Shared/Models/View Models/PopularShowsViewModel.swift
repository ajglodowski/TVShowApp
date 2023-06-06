//
//  PopularShowsViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/23.
//

import Foundation
import Swift
import Firebase
import AlgoliaSearchClient

struct ShowCountResult: Identifiable {
    let showId:  String
    let updateCount: Int
    var id: String { self.showId }
}

class PopularShowsViewModel: ObservableObject {
    
    @Published var totalMostPopularShows = [Show]()
    
    @MainActor
    func getPopularShowsFromAll(modelData: ModelData) {
        
        let client = SearchClient(appID: "EXF4DPVMDL", apiKey: "10e81ef592f852d7c25580f7ec0ca771")
        let index = client.index(withName: "updates")
        
        var query = Query()
        query.facets = ["showId"]

        index.search(query: query) { result in
            switch result {
            case .success(let response):
                let facets = response.facets!
                let values = facets["showId"]!
                for value in values {
                    let add = ShowCountResult(showId: value.value, updateCount: value.count)
                    if (modelData.showDict[add.showId] != nil) {
                        ShowDetailViewModel().loadShow(modelData: modelData, id: add.showId)
                    }
                    if (modelData.showDict[add.showId] != nil) {
                        self.totalMostPopularShows.append(modelData.showDict[add.showId]!)
                    }
                }
            case .failure(let error):
                print("Algolia search error: \(error)")
            }
        }
    }
    
}

//
//  ShowDetailActorsViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/16/24.
//

import Foundation

class ShowDetailActorsViewModel: ObservableObject {
    
    @Published var actors: [Actor]? = nil
    
    @MainActor
    func setActors(actorList: [Actor]) {
        self.actors = actorList
        dump(self.actors)
    }
    
    func fetchActors(showId: Int) async {
        let actors = await getActorsForShow(showId: showId)
        await setActors(actorList: actors)
    }
    
}

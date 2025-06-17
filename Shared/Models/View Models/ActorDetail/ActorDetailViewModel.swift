//
//  ActorDetailViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 2/1/23.
//

import Foundation

import Foundation
import Swift
import Firebase

class ActorDetailViewModel: ObservableObject {
    
    @Published var actor: Actor? = nil
    @Published var shows: [Show]? = nil
    
    @MainActor 
    func setActorData(actor: Actor, shows: [Show]) {
        self.actor = actor
        self.shows = shows
    }
    
    func fetchAllActorData(actorId: Int) async {
        let actorInfo = await getActorInfo(actorId: actorId)
        let showData = await getShowsForActor(actorId: actorId)
        if (actorInfo == nil) { return }
        await setActorData(actor: actorInfo!, shows: showData)
    }
    
}

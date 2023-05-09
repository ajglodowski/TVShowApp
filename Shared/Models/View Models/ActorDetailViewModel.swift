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
    
    private var fireStore = Firebase.Firestore.firestore()
    
    @MainActor
    func loadActor(modelData: ModelData, id: String) {
        let show = fireStore.collection("actors").document(id)
        show.getDocument { document, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let document = document {
                let optData = document.data()
                if (optData == nil) { return }
                let data = optData!
                
                let name = data["actorName"] as! String
                let shows = data["shows"] as? [String:String] ?? [String:String]()
                
                var add = Actor(id: id)
                add.name = name
                add.shows = shows
                modelData.loadedActors[id] = add
                
            }
        }
    }
    
}

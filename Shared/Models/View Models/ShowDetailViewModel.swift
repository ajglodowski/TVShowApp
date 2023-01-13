//
//  ShowDetailViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ShowDetailViewModel: ObservableObject {
    
    @Published var show: Show? = nil
    @Published var profilePic: Image? = nil
    
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func loadShow(modelData: ModelData, id: String) {
        if (modelData.loadingShows.contains(id)) { return }
        modelData.loadingShows.insert(id)
        print("Doing fetch for \(id)")
        let show = fireStore.collection("shows").document("\(id)")
        show.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                let rawData = snapshot.data()
                if (rawData == nil) {
                    print("Attempting to load show with invalid id")
                    return
                }
                let data = rawData!
                var add = Show(id: show.documentID)
                
                let name = data["name"] as! String
                let running = data["running"] as! Bool
                let totalSeasons = data["totalSeasons"] as! Int
                let tags = data["tags"] as? [String] ?? [String]()
                let currentlyAiring = data["currentlyAiring"] as? Bool ?? false
                let service = data["service"] as! String
                let limitedSeries = data["limitedSeries"] as! Bool
                let length = data["length"] as! String
                
                let releaseDate = data["releaseDate"] as? Timestamp
                let airdate = data["airdate"] as? String
                
                let actors = data["actors"] as? [String: String]
                let statusCounts = data["statusCounts"] as! [String: Int]
                let ratingCounts = data["ratingCounts"] as! [String: Int]
                
                var tagArray = [Tag]()
                for tag in tags {
                    tagArray.append(Tag(rawValue: tag)!)
                }
                
                add.name = name
                add.running = running
                add.totalSeasons = totalSeasons
                add.tags = tagArray
                add.currentlyAiring = currentlyAiring
                add.service = Service(rawValue: service)!
                add.limitedSeries = limitedSeries
                add.length = ShowLength(rawValue: length)!
                if (airdate != nil) { add.airdate = AirDate(rawValue: airdate!) }
                add.releaseDate = releaseDate?.dateValue()
                if (actors != nil) { add.actors = actors }
                for (key, value) in statusCounts {
                    add.statusCounts[Status(rawValue: key)!] = value
                }
                for (key, value) in ratingCounts {
                    add.ratingCounts[Rating(rawValue: key)!] = value
                }

                self.show = add
                modelData.showDict[id] = add
                modelData.loadingShows.remove(id)
            }
        }
    }
    
}

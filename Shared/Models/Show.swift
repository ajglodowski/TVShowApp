//
//  Show.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import Foundation
import SwiftUI
import Combine

struct Show : Hashable, Identifiable, Codable {
    
    // Both
    var id : String // Needed for Actors
    //var id : String = UUID().uuidString // For Previous builds
    var name: String // Needed for Actors
    var service: Service // Needed for Actors
    var running: Bool
    var tags: [Tag]?
    var totalSeasons: Int
    var limitedSeries: Bool
    var length: ShowLength
    var releaseDate: Date?
    var airdate: AirDate?
    var statusCounts: [Status:Int]
    var ratingCounts: [Rating:Int]
    var avgRating: Double {
        var sum = 0
        var totalRatings = 0
        for (key, value) in ratingCounts {
            totalRatings += value
            sum += (key.pointValue * value)
        }
        //if (totalRatings == 0 || sum == 0) { return 0 }
        return Double(sum) / Double(totalRatings)
    }
    
    // User Specific
    var addedToUserShows: Bool {
        if self.status != nil { return true }
        else { return false }
    }
    var status: Status?
    var currentSeason: Int?
    var rating: Rating?
    var lastUpdateDate: Date?
    var lastUpdateMessage: String?
    
    // Show Detail
    var actors: [String: String]? // Added var, key is id and value is name
    var currentlyAiring: Bool
    
    
    // Removing
    var wanted: Bool?
    var discovered: Bool?
    var watched: Bool?
    
    init(id: String) {
        //id = generateShowId()
        self.id = id
        self.name = "New Show"
        self.service = Service.Other
        self.length = ShowLength.min
        //self.status = Status.Other
        //self.airdate = AirDate.Other
        //self.watched = false
        self.running = true
        self.totalSeasons = 1
        //self.currentSeason = 1
        self.limitedSeries = false
        self.tags = [Tag]()
        self.currentlyAiring = false
        self.statusCounts = [Status.CatchingUp: 0, Status.ComingSoon: 0, Status.CurrentlyAiring: 0, Status.NeedsWatched: 0,
                             Status.NewRelease: 0, Status.NewSeason: 0, Status.Other: 0, Status.SeenEnough: 0,
                             Status.ShowEnded: 0, Status.UpToDate: 0]
        self.ratingCounts = [Rating.Disliked: 0, Rating.Meh: 0, Rating.Liked: 0, Rating.Loved: 0]
        //self.rating = Rating.Meh
        //actors = []
        //super.init()
    }
    
    
   //private enum CodingKeys : String, CodingKey { case name, service, wanted, status, running, watched, length, discovered, airdate, totalSeasons, currentSeason, releaseDate, limitedSeries, rating, tags, actors }
    

    func equals(input: Show) -> Bool {
        if (input.name == self.name && input.service == self.service) { return true }
        else { return false }
    }
    
    /*
    mutating func addActor(toAdd: Actor) {
        if (!actors.contains(toAdd)) { actors.append(toAdd); }
    }
     */
    

}

/*
class ShowStore: ObservableObject {
    @Published var shows = [Show]()
}
 */

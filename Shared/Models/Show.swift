//
//  Show.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase

struct Show : Hashable, Identifiable {
    
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
    var currentUserUpdates: [UserUpdate]?
    var lastUpdateDate: Date? {
        currentUserUpdates?.max { $0.updateDate > $1.updateDate }?.updateDate
    }
    
    // Show Detail
    var actors: [String: String]? // Added var, key is id and value is name
    var currentlyAiring: Bool
    
    // Images
    var tileImage: UIImage?
    var fullImage: UIImage?
    
    // Removing
    var wanted: Bool?
    var discovered: Bool?
    var watched: Bool?
    
    init(id: String) {
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
    }
    
    
   //private enum CodingKeys : String, CodingKey { case name, service, wanted, status, running, watched, length, discovered, airdate, totalSeasons, currentSeason, releaseDate, limitedSeries, rating, tags, actors }
    

    func equals(input: Show) -> Bool {
        if (input.name == self.name && input.service == self.service) { return true }
        else { return false }
    }
    
}

func convertShowToDictionary(show: Show) -> [String:Any] {
    var output = [String:Any]()
    
    //output["id"] = show.id
    output["name"] = show.name
    output["service"] = show.service.rawValue
    output["running"] = show.running
    output["totalSeasons"] = show.totalSeasons
    output["limitedSeries"] = show.limitedSeries
    output["length"] = show.length.rawValue
    output["currentlyAiring"] = show.currentlyAiring
    if (show.releaseDate != nil) { output["releaseDate"] = show.releaseDate! }
    if (show.airdate != nil) { output["airdate"] = show.airdate!.rawValue }
    
    if (show.tags != nil) {
        output["tags"] = show.tags!.map { $0.rawValue }
    }
    
    if (show.actors != nil && !show.actors!.isEmpty) {
        output["actors"] = show.actors
    }
    
    var stringStatusCounts = [String:Int]()
    for (key, value) in show.statusCounts {
        stringStatusCounts[key.rawValue] = value
    }
    output["statusCounts"] = stringStatusCounts
    
    var stringRatingCounts = [String:Int]()
    for (key, value) in show.ratingCounts {
        stringRatingCounts[key.rawValue] = value
    }
    output["ratingCounts"] = stringRatingCounts
    
    /*
    // User Specific
    var status: Status?
    var currentSeason: Int?
    var rating: Rating?
     */
    
    //var tags: [Tag]
    
    return output
}

func convertShowDictToShow(showId: String, data: [String:Any]) -> Show {
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
    
    var out = Show(id: showId)
    out.name = name
    out.running = running
    out.totalSeasons = totalSeasons
    out.tags = tagArray
    out.currentlyAiring = currentlyAiring
    out.service = Service(rawValue: service)!
    out.limitedSeries = limitedSeries
    out.length = ShowLength(rawValue: length)!
    if (airdate != nil) { out.airdate = AirDate(rawValue: airdate!) }
    out.releaseDate = releaseDate?.dateValue()
    if (actors != nil) { out.actors = actors }
    for (key, value) in statusCounts {
        out.statusCounts[Status(rawValue: key)!] = value
    }
    for (key, value) in ratingCounts {
        out.ratingCounts[Rating(rawValue: key)!] = value
    }
    
    return out
}

func mergeShowTypes(userData: Show, showData: Show) -> Show {
    var combined = showData
    combined.status = userData.status
    combined.currentSeason = userData.currentSeason
    combined.rating = userData.rating
    return combined
}


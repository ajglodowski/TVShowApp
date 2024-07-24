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

var SampleShow: Show {
    var show = Show(id: -1)
    show.name = "Sample Show"
    show.airdate = AirDate.Sunday
    show.totalSeasons = 3
    show.service = Service.Netflix
    /*show.statusCounts = [Status.CatchingUp: 0, Status.ComingSoon: 0, Status.CurrentlyAiring: 0, Status.NeedsWatched: 0,
                         Status.NewRelease: 0, Status.NewSeason: 10, Status.Other: 0, Status.SeenEnough: 0,
                         Status.ShowEnded: 0, Status.UpToDate: 25] */
    show.ratingCounts = [Rating.Disliked: 0, Rating.Meh: 10, Rating.Liked: 5, Rating.Loved: 1]
    return show
}

struct Show : Hashable, Identifiable {
    
    // Both
    var id : Int
    var name: String
    var lastUpdated: Date // Date the show was last updated
    var created: Date
    var supabaseService: SupabaseService
    var service: Service
    var services: [Service]? // Handled differently than firebase
    var running: Bool
    var tags: [Tag]? // Handled differently than firebase
    var totalSeasons: Int
    var limitedSeries: Bool
    var length: ShowLength
    var releaseDate: Date?
    var airdate: AirDate?
    var statusCounts: [Status:Int]? // Handled differently than firebase
    var ratingCounts: [Rating:Int]? // Handled differently than firebase
    var currentlyAiring: Bool
    var avgRating: Double? {
        if (ratingCounts == nil) { return 0 }
        var sum = 0
        var totalRatings = 0
        for (key, value) in ratingCounts! {
            totalRatings += value
            sum += (key.pointValue * value)
        }
        //if (totalRatings == 0 || sum == 0) { return 0 }
        return Double(sum) / Double(totalRatings)
    }
    var partiallyLoaded: Bool? // deprecated with firebase deprecation
    
    // User Specific
    var userSpecificValues: ShowUserSpecificDetails?
    var addedToUserShows: Bool {
        if self.userSpecificValues != nil { return true }
        else { return false }
    }
    
    
    
    
    // Show Detail
    var actors: [Int : Actor]?
  
    // Images
    var tileImage: UIImage?
    var fullImage: UIImage?
    
    // Removing
    var wanted: Bool?
    var discovered: Bool?
    var watched: Bool?
    
    init(id: Int) {
        self.id = id
        self.name = "New Show"
        self.lastUpdated = Date()
        self.created = Date()
        self.supabaseService = MockSupabaseService
        self.service = Service.Other
        //self.services = [Service.Other]
        self.length = ShowLength.min
        //self.status = Status.Other
        //self.airdate = AirDate.Other
        //self.watched = false
        self.running = true
        self.totalSeasons = 1
        //self.currentSeason = 1
        self.limitedSeries = false
        //self.tags = [Tag]()
        self.currentlyAiring = false
        /*
        self.statusCounts = [Status.CatchingUp: 0, Status.ComingSoon: 0, Status.CurrentlyAiring: 0, Status.NeedsWatched: 0,
                             Status.NewRelease: 0, Status.NewSeason: 0, Status.Other: 0, Status.SeenEnough: 0,
                             Status.ShowEnded: 0, Status.UpToDate: 0]
         
        self.ratingCounts = [Rating.Disliked: 0, Rating.Meh: 0, Rating.Liked: 0, Rating.Loved: 0]
         */
        //self.partiallyLoaded = false
    }
    
    init(from: SupabaseShow) {
        self.id = from.id
        self.name = from.name
        self.lastUpdated =  from.lastUpdated
        self.created = from.created_at
        self.running = from.running
        self.totalSeasons = from.totalSeasons
        self.currentlyAiring = from.currentlyAiring
        self.supabaseService = from.service
        var service = Service(rawValue: from.service.name)
        if (service == nil) { service = Service.Other }
        self.service = service!
        self.limitedSeries = from.limitedSeries
        self.length = from.length
        self.airdate = from.airdate
        self.releaseDate = nil
        if (from.releaseDate != nil) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let someDateTime = formatter.date(from: from.releaseDate!)
            if (someDateTime != nil) { self.releaseDate = someDateTime! }
        }
    }
    
    
   //private enum CodingKeys : String, CodingKey { case name, service, wanted, status, running, watched, length, discovered, airdate, totalSeasons, currentSeason, releaseDate, limitedSeries, rating, tags, actors }
    

    func equals(input: Show) -> Bool {
        if (input.name == self.name && input.service == self.service) { return true }
        else { return false }
    }
    
}

/*
func convertShowToDictionary(show: Show) -> [String:Any] {
    var output = [String:Any]()
    
    //output["id"] = show.id
    output["name"] = show.name
    output["lastUpdated"] = show.lastUpdated
    output["service"] = show.service.rawValue
    output["services"] = show.services.map { $0.rawValue }
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
    
    return output
}

func convertShowDictToShow(showId: String, data: [String:Any]) -> Show {
    let name = data["name"] as! String
    let lastUpdated = data["lastUpdated"] as! Timestamp
    let running = data["running"] as! Bool
    let totalSeasons = data["totalSeasons"] as! Int
    let tags = data["tags"] as? [String] ?? [String]()
    let currentlyAiring = data["currentlyAiring"] as? Bool ?? false
    let service = data["service"] as! String
    let services = data["services"] as? [String] ?? [String] ()
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
    out.lastUpdated = lastUpdated.dateValue()
    out.running = running
    out.totalSeasons = totalSeasons
    out.tags = tagArray
    out.currentlyAiring = currentlyAiring
    out.service = Service(rawValue: service)!
    out.services = services.map { Service(rawValue: $0)! }
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
*/
func mergeShowTypes(userData: Show, showData: Show) -> Show {
    var combined = showData
    combined.userSpecificValues = userData.userSpecificValues
    return combined
}


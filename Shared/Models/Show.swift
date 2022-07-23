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
    var name: String
    var service: Service
    var wanted: Bool
    var status: Status
    var running: Bool
    var watched: Bool
    
    //var actors: [Actor]
    
    let id : String = UUID().uuidString
    var length: ShowLength
    var discovered: Bool
    var airdate: AirDate
    
    var totalSeasons: Int
    var currentSeason: Int
    
    var releaseDate: Date?
    var limitedSeries: Bool
    var rating: Rating?
    
    init() {
        //id = generateShowId()
        //self.id = UUID().uuidString
        self.name = "New Show"
        self.service = Service.Other
        self.length = ShowLength.min
        self.status = Status.Other
        self.airdate = AirDate.Other
        self.watched = false
        self.running = true
        self.wanted = true
        self.discovered = true
        self.totalSeasons = 1
        self.currentSeason = 1
        self.limitedSeries = false
        self.rating = Rating.Meh
        //self.releaseDate = Date()
        //actors = []
        //super.init()
    }
    
    private enum CodingKeys : String, CodingKey { case name, service, wanted, status, running, watched, length, discovered, airdate, totalSeasons, currentSeason, releaseDate, limitedSeries, rating }
    
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

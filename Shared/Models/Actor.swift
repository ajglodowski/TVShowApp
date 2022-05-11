//
//  Actor.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import Foundation
import SwiftUI
import Combine

struct Actor : Hashable, Identifiable, Codable {
    //var id: Int
    var name: String
    var shows: [Show]
    
    let id : String = UUID().uuidString
    
    init() {
        print("Start init")
        //id = generateActorId()
        name = "New Actor"
        shows = []
        print("end init")
    }
    
    mutating func addShow(toAdd: Show) {
        if (!shows.contains(where: { $0.equals(input: toAdd)})) { shows.append(toAdd); }
    }
    
    func equals(input: Actor) -> Bool {
        if (input.name == self.name) { return true }
        else { return false }
    }
    
    private enum CodingKeys : String, CodingKey { case name, shows }

}

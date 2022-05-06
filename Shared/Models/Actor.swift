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
    var id: Int
    var name: String
    var shows: [Show]
    
    init() {
        id = generateShowId()
        name = "New Actor"
        shows = []
    }
    
    mutating func addShow(toAdd: Show) {
        if (!shows.contains(toAdd)) { shows.append(toAdd); }
    }
    

}

func generateActorId() -> Int {
    var val = 1000 + ModelData().actors.count
    while (ModelData().shows.contains(where: {$0.id == val })) { val += 1 }
    return val
}

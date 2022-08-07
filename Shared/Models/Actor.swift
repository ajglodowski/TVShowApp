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
    let id: String
    var name: String
    //var shows: [Show]
    var shows: [String: String]
    
    //let id : String = UUID().uuidString
    
    init(id: String) {
        self.id = id
        self.name = "New Actor"
        self.shows = [String:String]()
        //self.shows = [Show]()
    }
    /*
    mutating func addShow(toAdd: Show) {
        if (shows[toAdd.id] == nil) {
            shows[toAdd.id] = toAdd.name
        }
    }
     */
    
    //private enum CodingKeys : String, CodingKey { case name, shows }

}

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

    init(id: Int) {
        self.id = id
        self.name = "New Actor"
    }
}

let ActorProperties = "id, name"

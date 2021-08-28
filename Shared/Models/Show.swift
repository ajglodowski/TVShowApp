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
    
    var id: Int
    
    var length: ShowLength
    var discovered: Bool
    var airdate: AirDate
    
    init() {
        id = 1000 + ModelData().shows.count + 2
        name = "New Show"
        service = Service.Other
        length = ShowLength.min
        status = Status.Other
        airdate = AirDate.Other
        watched = false
        running = true
        wanted = true
        discovered = true
    }

}


/*
class ShowStore: ObservableObject {
    @Published var shows = [Show]()
}
 */

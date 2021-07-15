//
//  Show.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import Foundation
import SwiftUI
import Combine

/*
enum ShowLength : String, Codable, CaseIterable {
    case "30", "60"
}
 */


struct Show : Hashable, Identifiable, Codable {
    var id: Int
    var name: String
    var service: Service
    var length: ShowLength
    var status: String
    var watched: Bool
    var running: Bool
    var wanted: Bool
    var discovered: Bool
    
    init() {
        id = 1000 + ModelData().shows.count + 1
        name = ""
        service = Service.Other
        length = ShowLength.min
        status = ""
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

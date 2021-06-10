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
    var status: String
    var watched: Bool
    var running: Bool
    var wanted: Bool
    
    //var length: ShowLength

}


/*
class ShowStore: ObservableObject {
    @Published var shows = [Show]()
}
 */

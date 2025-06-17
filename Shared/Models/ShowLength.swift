//
//  ShowLength.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/10/21.
//

import Foundation

enum ShowLength: String, CaseIterable, Codable, Identifiable {
    case none = "None"
    case min = "<30"
    case thirty = "30"
    case between = "30-60"
    case sixty = "60"
    case max = "60+"
    
    var id: String { self.rawValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        // Try to initialize with the raw value
        if let value = ShowLength(rawValue: rawValue) {
            self = value
        } else {
            // If decoding fails, print debug info and default to .none
            print("ShowLength decoding failed for value: '\(rawValue)'. Defaulting to .none")
            self = .none
        }
    }
}

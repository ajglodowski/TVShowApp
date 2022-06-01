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
}

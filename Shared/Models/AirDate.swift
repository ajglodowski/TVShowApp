//
//  AirDate.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/17/21.
//

import Foundation

enum AirDate: String, CaseIterable, Codable, Identifiable {
    
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    case Other
    
    var id: String { self.rawValue }
}

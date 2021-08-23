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
    
    var id: Int {
        switch self.rawValue {
        case "Sunday":
            return 0
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        case "Other":
            return 7
        default:
            return 8
        }
        
    }
}

//
//  Service.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/10/21.
//

import Foundation

enum Service: String, CaseIterable, Codable, Identifiable {
    case AMC = "AMC"
    case ABC
    case Amazon
    case Apple = "Apple TV+"
    case HBO
    case CW
    case Disney = "Disney+"
    case FX
    case Hulu
    case NBC
    case Netflix
    case Showtime
    case USA
    case Viceland
    
    var id: String { self.rawValue }
}


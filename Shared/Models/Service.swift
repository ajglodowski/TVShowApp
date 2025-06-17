//
//  Service.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/10/21.
//

import Foundation
import SwiftUI

enum Service: String, CaseIterable, Codable, Identifiable {
    case AMC = "AMC"
    case ABC
    case Amazon
    case Apple = "Apple TV+"
    case HBO
    case Max
    case CW
    case Disney = "Disney+"
    case FX
    case Hulu
    case NBC
    case Netflix
    case Showtime
    case USA
    case Viceland
    
    case Other
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch(self) {
        case Service.AMC, Service.ABC, Service.Apple, Service.FX, Service.USA, Service.Viceland, Service.Other:
            return .white
        case Service.Amazon:
            return Color(red: 0/255, green: 168/255, blue: 225/255)
        case Service.Max:
            return Color(red: 0/255, green: 43/255, blue: 231/255)
        case Service.CW:
            return .green
        case Service.Disney:
            return Color(red: 17/255, green: 70/255, blue: 207/255)
        case Service.Hulu:
            return Color(red: 28/255, green: 231/255, blue: 131/255)
        case Service.NBC:
            return .yellow
        case Service.Netflix:
            return Color(red: 229/255, green: 9/255, blue: 20/255)
        case Service.Showtime:
            return .red
        default:
            return .white
        }
    }
    
}

func getServiceColor(service: Service) -> Color {
    let colors = [Service.HBO: Color(red: 102/255, green: 51/255, blue: 153/255), Service.Hulu: Color(.green), Service.Netflix: Color(red: 229/255, green: 9/255, blue: 20/255), Service.Disney: Color(red: 17/255, green: 70/255, blue: 207/255), Service.Amazon: Color(red: 0/255, green: 168/255, blue: 225/255)
    ]
    return colors[service] ?? Color(.darkGray)
}


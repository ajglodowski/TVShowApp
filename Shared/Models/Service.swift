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
}

func getServiceColor(service: Service) -> Color {
    let colors = [Service.HBO: Color(red: 102/255, green: 51/255, blue: 153/255), Service.Hulu: Color(.green), Service.Netflix: Color(red: 229/255, green: 9/255, blue: 20/255), Service.Disney: Color(red: 17/255, green: 70/255, blue: 207/255), Service.Amazon: Color(red: 0/255, green: 168/255, blue: 225/255)
    ]
    return colors[service] ?? Color(.darkGray)
}


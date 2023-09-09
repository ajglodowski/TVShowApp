//
//  Rating.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/23/22.
//

import Foundation
import SwiftUI

enum Rating: String, CaseIterable, Codable, Identifiable {
    case Disliked
    case Meh
    case Liked
    case Loved
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch(self) {
        case Rating.Disliked:
            return .red
        case Rating.Meh:
            return .yellow
        case Rating.Liked:
            return .blue
        case Rating.Loved:
            return .green
        default:
            return .purple
        }
    }
    
    var pointValue: Int {
        switch(self) {
        case Rating.Disliked:
            return -2
        case Rating.Meh:
            return 0
        case Rating.Liked:
            return 1
        case Rating.Loved:
            return 3
        default:
            return 0
        }
    }
    
    var ratingSymbol: String {
        switch(self) {
        case Rating.Disliked:
            return "hand.thumbsdown"
        case Rating.Meh:
            return "minus.circle"
        case Rating.Liked:
            return "hand.thumbsup"
        case Rating.Loved:
            return "heart"
        default:
            return "questionmark"
        }
    }
    
}

//
//  Rating.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/23/22.
//

import Foundation

enum Rating: String, CaseIterable, Codable, Identifiable {
    case Disliked
    case Meh
    case Liked
    case Loved
    
    var id: String { self.rawValue }
}

func getRatingSymbol(rating: Rating) -> String {
    let colors = [Rating.Disliked: "hand.thumbsdown", Rating.Meh: "minus.circle", Rating.Liked: "hand.thumbsup", Rating.Loved: "heart"
    ]
    return colors[rating] ?? "exclamationmark.circle"
}

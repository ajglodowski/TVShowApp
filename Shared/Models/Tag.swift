//
//  Tag.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/24/22.
//

import Foundation

enum TagCategory: String, CaseIterable, Codable, Identifiable {
    case None
    case Genre
    case Theme
    case Producer
    case Collection
    
    var id: String { self.rawValue }
}

enum Tag: String, CaseIterable, Codable, Identifiable {
    
    case None
    
    case Drama
    case Comedy
    case Sitcom
    case Scifi
    case Fantasy
    case Thriller
    case Reality
    case Romance
    
    case ComingofAge = "Coming of Age"
    case Teen
    case StrugglingAdult = "Struggling Adults"
    case Satire
    case Superhero
    case Sports
    case Historical
    
    case MichaelSchur = "Michael Schur"
    case IssaRae = "Issa Rae"
    case MindyKaling = "Mindy Kaling"
    case PheobeWallerBridge = "Phoebe Waller-Bridge"
    case RyanMurphy = "Ryan Murphy"
    case SallyRooney = "Sally Rooney"
    
    case GameOfThrones = "Game of Thrones"
    case OldMarvel = "Old Marvel"
    case NewMarvel = "New Marvel"
    case StarWars = "Star Wars"
    
    var category: TagCategory {
        if (self.id == 0) {
            return TagCategory.None
        } else if (self.id < 101) {
            return TagCategory.Genre
        } else if (self.id > 100 && self.id < 201) {
            return TagCategory.Theme
        } else if (self.id > 200 && self.id < 301) {
            return TagCategory.Producer
        } else {
            return TagCategory.Collection
        }
    }
    
    var id: Int {
        switch self.rawValue {
        case "None":
            return 0
        case "Drama":
            return 1
        case "Comedy":
            return 2
        case "Sitcom":
            return 3
        case "Scifi":
            return 4
        case "Fantasy":
            return 5
        case "Thriller":
            return 6
        case "Reality":
            return 7
        case "Romance":
            return 8
        case "Coming of Age":
            return 101
        case "Teen":
            return 102
        case "Struggling Adults":
            return 103
        case "Satire":
            return 104
        case "Superhero":
            return 105
        case "Sports":
            return 106
        case "Historical":
            return 107
        case "Michael Schur":
            return 201
        case "Issa Rae":
            return 202
        case "Mindy Kaling":
            return 203
        case "Phoebe Waller-Bridge":
            return 204
        case "Ryan Murphy":
            return 205
        case "Sally Rooney":
            return 206
        case "Game of Thrones":
            return 301
        case "Old Marvel":
            return 302
        case "New Marvel":
            return 303
        case "Star Wars":
            return 304
        default:
            return 0
        }
    }
}

//
//  Tag.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/24/22.
//

import Foundation

struct TagCategory:  Hashable, Codable, Identifiable {
    var id : Int
    var created_at: Date
    var name: String
    
    var icon: String? {
        switch name {
        case "None":
            return "minus.circle"
        case "Genre":
            return "theatermasks"
        case "Theme":
            return "lightbulb"
        case "Producer":
            return "person.3"
        case "Collection":
            return "folder"
        case "Attribute":
            return "tag"
        default:
            return nil
        }
    }
    
}
let TagCategoryProperties = "id, created_at, name"

struct Tag: Hashable, Codable, Identifiable {
    var id: Int
    var created_at: Date
    var name: String
    var category: TagCategory
}
let TagProperties = "id, created_at, name, category (\(TagCategoryProperties))"
let NestedTagProperties = "showTag (id, created_at, name, category (id, created_at, name))"

struct ShowTagDTO: Hashable, Codable {
    var showTag: Tag
}

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

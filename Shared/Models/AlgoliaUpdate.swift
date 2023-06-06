//
//  AlgoliaUpdate.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/4/23.
//

import Foundation
import SwiftUI
import Combine

struct AlgoliaUpdate : Codable {
    
    var userId: String
    var showId: String
    var updateType: UserUpdateCategory
    var updateDate: Date

}

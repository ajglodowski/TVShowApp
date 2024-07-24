//
//  Status.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/17/21.
//

import Foundation

import Foundation

struct Status : Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var created_at: Date
    var update_at: Date
}

let StatusProperties = "id, created_at, update_at, name"
let ShowEndedStatusId = 1
let UpToDateStatusId = 2
let NeedsWatchedStatusId = 3
let SeenEnoughStatusId = 4
let CurrentlyAiringStatusId = 5
let NewReleaseStatusId = 6
let NewSeasonStatusId = 7
let CatchingUpStatusId = 8
let ComingSoonStatusId = 9
var MockStatus = Status(id: 1, name: "Needs Watched", created_at: Date(), update_at: Date())


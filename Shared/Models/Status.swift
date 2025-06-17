//
//  Status.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/17/21.
//

import Foundation

struct Status : Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var created_at: Date
    var update_at: Date

    private var statusType: String {
        let statusName = self.name.lowercased()
        
        if statusName.contains("show ended") || statusName.contains("ended") {
            return "show-ended"
        }
        if statusName.contains("up to date") || statusName.contains("up-to-date") {
            return "up-to-date"
        }
        if statusName.contains("needs watched") || statusName.contains("need to watch") {
            return "needs-watched"
        }
        if statusName.contains("seen enough") || statusName.contains("dropped") {
            return "seen-enough"
        }
        if statusName.contains("currently airing") || statusName.contains("airing") {
            return "currently-airing"
        }
        if statusName.contains("new release") {
            return "new-release"
        }
        if statusName.contains("new season") || statusName.contains("season") {
            return "new-season"
        }
        if statusName.contains("catching up") || statusName.contains("catching-up") {
            return "catching-up"
        }
        if statusName.contains("coming soon") || statusName.contains("coming-soon") {
            return "coming-soon"
        }
        if statusName.contains("rewatching") || statusName.contains("rewatch") {
            return "rewatching"
        }
        
        return "unknown"
    }

    var icon: String {
        switch statusType {
        case "show-ended":
            return "checklist.checked"
        case "up-to-date":
            return "checkmark.arrow.trianglehead.counterclockwise"
        case "needs-watched":
            return "eye"
        case "seen-enough":
            return "xmark.circle"
        case "currently-airing":
            return "dot.radiowaves.left.and.right"
        case "new-release":
            return "sparkles"
        case "new-season":
            return "alarm"
        case "catching-up":
            return "chart.line.uptrend.xyaxis"
        case "coming-soon":
            return "calendar"
        case "rewatching":
            return "arrow.clockwise"
        default:
            return "play.circle"
        }
    }
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


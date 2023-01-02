//
//  ShowHelpers.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/8/21.
//

import Foundation
import Firebase
import UIKit

func getRandPic(shows: [Show]) -> String {
    var x = 0
    var showName = shows[0].name
    var counter = 0
    var exists = false
    repeat {
        //print(x)
        x = Int.random(in: 0..<shows.count)
        showName = shows[x].name
        counter += 1
        exists = UIImage(named: showName) != nil
    } while (!exists && (counter < (shows.count * shows.count)))
    
    if (!exists) {
        showName = "broken"
    }
    return showName
}

func applyLengthFilter(shows: [Show], selection: ShowLength) -> [Show] {
    return shows.filter { $0.length == selection }
}

func applyTagFilters(tagFilters: [Tag], shows: [Show]) -> [Show] {
    if (!tagFilters.isEmpty) {
        var output: [Show] = []
        for tag in tagFilters {
            if (tag == Tag.None) {
                output.append(contentsOf: shows.filter { ($0.tags ?? []).isEmpty })
            } else {
                output.append(contentsOf: shows.filter { ($0.tags ?? []).contains(tag)})
            }
        }
        return Array(Set(output))
    } else {
        return shows
    }
}

func applyRatingFilters(ratingFilters: [Rating?], shows:[Show]) -> [Show] {
    return !ratingFilters.isEmpty ? shows.filter { ratingFilters.contains($0.rating ?? nil) } : shows
}

func applyAllFilters(serviceFilters: [Service], statusFilters: [Status]?, ratingFilters: [Rating?], tagFilters: [Tag], showLengthFilter: ShowLength, shows: [Show], selectedLimited: Int, selectedRunning: Int, selectedAiring: Int, appliedAirdateFilters: [AirDate?]) -> [Show] {
    var filtered = [Show]()
    if (!serviceFilters.isEmpty) {
        for service in serviceFilters {
            let add = shows.filter { $0.service == service}
            filtered.append(contentsOf: add)
        }
    } else {
        filtered = shows
    }
    
    if (statusFilters != nil && !statusFilters!.isEmpty) { filtered = filtered.filter { statusFilters!.contains($0.status!) } }
    
    if (!appliedAirdateFilters.isEmpty) { filtered = filtered.filter { appliedAirdateFilters.contains($0.airdate ?? nil) } }
    
    filtered = applyRatingFilters(ratingFilters: ratingFilters, shows: filtered)
    
    filtered = applyTagFilters(tagFilters: tagFilters, shows: filtered)
    
    if (showLengthFilter != ShowLength.none) { filtered = filtered.filter { $0.length == showLengthFilter} }
    
    switch selectedLimited {
        case 1:
            filtered = filtered.filter { $0.limitedSeries == false}
        case 2:
            filtered = filtered.filter { $0.limitedSeries == true}
        default:
            break
    }
    
    switch selectedRunning {
        case 1:
            filtered = filtered.filter { $0.running == true }
        case 2:
            filtered = filtered.filter { $0.running == false }
        default:
            break
    }
    
    switch selectedAiring {
        case 1:
            filtered = filtered.filter { $0.currentlyAiring == true }
        case 2:
            filtered = filtered.filter { $0.currentlyAiring == false }
        default:
            break
    }
    
    return filtered
}

/*
 // Deprecated with Firestore
func getActors(showIn: Show, actors: [Actor]) -> [Actor] {
    var output : [Actor] = []
    for specificActor in actors {
        for specificShow in specificActor.shows {
            if (specificShow.equals(input: showIn)) {
                output.append(specificActor)
            }
        }
    }
    return output
}
 */

func printActorList(input: [Actor]) {
    for act in input {
        print("\(act.name) ->")
    }
}

func printShowList(input: [Show]) {
    for show in input {
        print("\(show.name) ->")
    }
}

// Calls all the firebase functions needed to update a status
func changeShowStatus(show: Show, status: Status) {
    var updatedShow = show
    switch status {
    case Status.ShowEnded:
        updatedShow.running = false
    case Status.CurrentlyAiring:
        if (show.airdate == nil) {
            updatedShow.airdate = AirDate.Other
        }
    case Status.ComingSoon:
        if (show.releaseDate == nil) {
            updatedShow.releaseDate = Date()
        }
    default:
        break
    }
    //updateShowStatus(showId: show.id, status: status)
    updatedShow.status = status
    //updatedShow.lastUpdateDate = Date()
    //updatedShow.lastUpdateMessage = "Updated status to \(status.rawValue)"
    addUserUpdateStatusChange(userId: Auth.auth().currentUser!.uid, show: updatedShow)
    updateUserShow(show: updatedShow)
    decrementStatusCount(showId: show.id, status: show.status!)
    incrementStatusCount(showId: show.id, status: status)
}

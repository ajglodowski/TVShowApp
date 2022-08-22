//
//  ShowHelpers.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/8/21.
//

import Foundation
import UIKit

/*
func showIndex(show: Show) -> Int {
    let ind = ModelData().shows.firstIndex(where: { $0.id == show.id})!
    return ind
}
 */

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

func applyServiceFilter(applied: [Service], shows: [Show], serivce: Service) -> [Show] {
    if (!applied.contains(serivce)) {
        let add: [Show] = ModelData().shows.filter { $0.service == serivce }
        var combined: [Show] = shows
        for new in add {
            combined.append(new)
        }
        return combined
    } else {
        let removed: [Show] = shows.filter { $0.service != serivce }
        return removed
    }
    
}

func applyLengthFilter(shows: [Show], selection: ShowLength) -> [Show] {
    
    let filtered: [Show] = ModelData().shows.filter { $0.length == selection }
    return filtered
}


// Shouldn't be used because ModelData doesn't update
func applyAllFilters(serviceFilters: [Service], showLengthFilter: ShowLength) -> [Show] {
    
    var filtered = [Show]()
    
    if (!serviceFilters.isEmpty) {
        for service in serviceFilters {
            let add = ModelData().shows.filter { $0.service == service}
            filtered.append(contentsOf: add)
        }
    } else {
        filtered = ModelData().shows
    }
    
    filtered = filtered.filter { $0.length == showLengthFilter}
    
    return filtered
    
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
    if (!ratingFilters.isEmpty) {
        var output = [Show]()
        for rating in ratingFilters {
            output.append(contentsOf: shows.filter{ $0.rating == rating})
        }
        return output
    } else {
        return shows
    }
}

func applyAllFilters(serviceFilters: [Service], statusFilters: [Status]?, ratingFilters: [Rating?], tagFilters: [Tag], showLengthFilter: ShowLength, shows: [Show], selectedLimited: Int) -> [Show] {
    var filtered = [Show]()
    if (!serviceFilters.isEmpty) {
        for service in serviceFilters {
            let add = shows.filter { $0.service == service}
            filtered.append(contentsOf: add)
        }
    } else {
        filtered = shows
    }
    
    if (statusFilters != nil && !statusFilters!.isEmpty) {
        filtered = filtered.filter {
            statusFilters!.contains($0.status!)
        }
    }
    
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
 

func getAirDateFromString(day: String) -> AirDate {
    switch day {
    case "Sunday":
        return AirDate.Sunday
    case "Monday":
        return AirDate.Monday
    case "Tuesday":
        return AirDate.Tuesday
    case "Wednesday":
        return AirDate.Wednesday
    case "Thursday":
        return AirDate.Thursday
    case "Friday":
        return AirDate.Friday
    case "Saturday":
        return AirDate.Saturday
    default:
        return AirDate.Other
    }
}

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

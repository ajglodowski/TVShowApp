//
//  ShowHelpers.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/8/21.
//

import Foundation
import UIKit

func showIndex(show: Show) -> Int {
    let ind = ModelData().shows.firstIndex(where: { _ in show.id == show.id })!
    return ind
}

func getRandPic(shows: [Show]) -> String {
    var x = 0
    var showName = shows[0].name
    var counter = 0
    var exists = false
    repeat {
        print(x)
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

func applyAllFilters(serviceFilters: [Service], showLengthFilter: ShowLength, shows: [Show]) -> [Show] {
    var filtered = [Show]()
    if (!serviceFilters.isEmpty) {
        for service in serviceFilters {
            let add = shows.filter { $0.service == service}
            filtered.append(contentsOf: add)
        }
    } else {
        filtered = shows
    }
    
    filtered = filtered.filter { $0.length == showLengthFilter}
    
    return filtered
}

func getActors(showIn: Show) -> [Actor] {
    
    var output : [Actor] = []
    for specificActor in ModelData().actors {
        for specificShow in specificActor.shows {
            if (specificShow.id == showIn.id) {
                output.append(specificActor)
            }
        }
    }
    return output
}


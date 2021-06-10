//
//  ShowHelpers.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/8/21.
//

import Foundation
import UIKit




func getRandPic(shows: [Show]) -> String {
    
    //@EnvironmentObject var modelData : ModelData
    
    //fatalError("Hehe")
    
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




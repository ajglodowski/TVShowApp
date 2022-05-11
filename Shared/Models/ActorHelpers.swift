//
//  ActorHelpers.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/10/22.
//

import Foundation
import UIKit

func actorIndex(actor: Actor) -> Int {
    let ind = ModelData().actors.firstIndex(where: { _ in actor.id == actor.id })!
    return ind
}

func removeShow(actor: Actor, remove: Show, shows:[Show]) -> [Show] {
    var out = [Show]()
    out = shows.filter { $0 != remove}
    return out
}

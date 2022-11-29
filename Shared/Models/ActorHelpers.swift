//
//  ActorHelpers.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/10/22.
//

import Foundation
import UIKit

func removeShow(actor: Actor, remove: Show, shows:[Show]) -> [Show] {
    return shows.filter { $0 != remove }
}

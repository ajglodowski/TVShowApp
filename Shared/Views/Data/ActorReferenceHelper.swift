//
//  ActorReferenceHelper.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/2/22.
//

import Foundation

func findShortestPath(showList: [Show],actorList: [Actor], startActor: Actor, destinationActor: Actor) -> [Actor] {
    //let returned = actorBfs(actorList: actorList, src: startActor, dest: destinationActor, actorHistory: [startActor], showHistory: [Show](), shortestLength: 100000)
    let returned = actorBfs(showList: showList, actorList: actorList, src: startActor, dest: destinationActor)
    //printShowList(input: returned)
    //printActorList(input: returned)
    //print(returned)
    
    if (!returned.isEmpty) {
        var path = [Actor]()
        var cur = destinationActor
        while (cur != startActor) {
            let prev = returned[cur]!
            path.append(cur)
            cur = prev
        }
        path.append(startActor)
        path = path.reversed()
        //printActorList(input: path)
        return path
    } else {
        print("No connection")
        return [Actor]()
    }
}
/*
func actorDfs(actorList: [Actor], src: Actor, dest: Actor, actorHistory: [Actor], showHistory: [Show], shortestLength: Int) -> [Actor] {
    
    if (src == dest && actorHistory.count < shortestLength) {
        //print(actorHistory)
        return actorHistory
    }
    
    for show in src.shows {
        if (!showHistory.contains(show)) {
            var newShowHistory = showHistory
            newShowHistory.append(show)
            for act in getActors(showIn: show, actors: actorList) {
                if (!actorHistory.contains(act)) {
                    print("Visiting actor: \(act.name)\n")
                    var newActorHistory = actorHistory
                    newActorHistory.append(act)
                    let path = actorDfs(actorList: actorList, src: act, dest: dest, actorHistory: newActorHistory, showHistory: newShowHistory, shortestLength: shortestLength)
                    if (!path.isEmpty) { return path }
                }
            }
        }
    }
    
    return [Actor]()
    
    
}
*/
func actorBfs(showList: [Show],actorList: [Actor], src: Actor, dest: Actor) -> [Actor:Actor] {
    
    var queue = [Actor]()
    var actorHistory = [Actor]()
    var showHistory = [String:String]()
    
    var pred = [Actor:Actor]()
    var dist = [Actor:Int]()
    
    actorHistory.append(src)
    dist[src] = 0
    queue.append(src)
    
    while (!queue.isEmpty) {
        let curActor = queue.remove(at: 0)
        //print(curActor.name)
        for (actorKey, showName) in curActor.shows {
            if (showHistory[actorKey] == nil) {
                showHistory[actorKey] = showName
                let showActorList = showList.first(where: { $0.id == actorKey})!.actors // Actor list of a specific show
                if (showActorList != nil) {
                    for (actorKey, actorName) in showActorList! {
                        let act = actorList.first(where: {$0.id == actorKey})!
                        if (!actorHistory.contains(act)) {
                            pred[act] = curActor
                            dist[act] = dist[curActor]! + 1
                            //print("Visiting actor: \(act.name)\n")
                            actorHistory.append(act)
                            queue.append(act)
                            //printActorList(input: queue)
                            if (act == dest) {
                                //print("Found")
                                return pred
                            }
                        }
                    }
                }
            }
        }
    }
    
    return [Actor:Actor]()
    
    
}

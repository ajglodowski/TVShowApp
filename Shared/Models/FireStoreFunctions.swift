//
//  FireStoreFunctions.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/4/22.
//

import Foundation
import Firebase

func convertShowToDictionary(show: Show) -> [String:Any] {
    var output = [String:Any]()
    
    //output["id"] = show.id
    output["name"] = show.name
    output["service"] = show.service.rawValue
    output["running"] = show.running
    output["totalSeasons"] = show.totalSeasons
    output["limitedSeries"] = show.limitedSeries
    output["length"] = show.length.rawValue
    output["currentlyAiring"] = show.currentlyAiring
    if (show.releaseDate != nil) { output["releaseDate"] = show.releaseDate! }
    if (show.airdate != nil) { output["airdate"] = show.airdate!.rawValue }
    
    if (show.tags != nil) {
        output["tags"] = show.tags!.map { $0.rawValue }
        
    } // Use for running
    
    if (show.actors != nil && !show.actors!.isEmpty) {
        print("Actor dict: \(show.actors!)\n")
        output["actors"] = show.actors
    }
    /*
    // User Specific
    var status: Status?
    var currentSeason: Int?
    var rating: Rating?
     */
    
    //var tags: [Tag]
    
    return output
}

func convertActorToDictionary(actor: Actor) -> [String:Any] {
    var output = [String:Any]()
    //output["id"] = actor.id
    output["actorName"] = actor.name
    //output["shows"] = actor.shows // For Final use
    return output
}

func convertUserShowToDictionary(show: Show) -> [String: Any] {
    var output = [String:Any]()
    output["showId"] = show.id
    output["status"] = show.status!.rawValue
    output["currentSeason"] = show.currentSeason!
    if (show.rating != nil) { output["rating"] = show.rating!.rawValue }
    return output
}

func addOrUpdateToUserShows(show: Show) {
    let uid = Auth.auth().currentUser!.uid
    let showData = convertUserShowToDictionary(show: show)
    Firestore.firestore().collection("users/\(uid)/shows").document("\(show.id)").setData(showData)
}

// Updating show properties in the current user's show collection
func updateToShows(show: Show) {
    let showData = convertShowToDictionary(show: show)
    Firestore.firestore().collection("shows").document("\(show.id)").setData(showData)
}

// Adding a new show to the shows collection
func addToShows(show: Show) -> String {
    let showData = convertShowToDictionary(show: show)
    let docRef = Firestore.firestore().collection("shows").document()
    docRef.setData(showData)
    return docRef.documentID
}

func addActorToActors(act: Actor) -> String {
    let actData = convertActorToDictionary(actor: act)
    let docRef = Firestore.firestore().collection("actors").document()
    docRef.setData(actData)
    return docRef.documentID
}

func updateActor(act: Actor) {
    let showData = convertActorToDictionary(actor: act)
    Firestore.firestore().collection("actors").document("\(act.id)").setData(showData)
}

func updateShowStatus(showId: String, status: Status) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users/\(uid)/shows").document("\(showId)").setData([
        "status": status.rawValue
    ], merge: true)
}

func addTagToShow(showId: String, tag: Tag) {
    Firestore.firestore().collection("shows").document("\(showId)").updateData([
        "tags": FieldValue.arrayUnion([tag.rawValue])
    ])
}

func removeTagFromShow(showId: String, tag: Tag) {
    Firestore.firestore().collection("shows").document("\(showId)").updateData([
        "tags": FieldValue.arrayRemove([tag.rawValue])
    ])
}

func updateCurrentSeason(newSeason: Int, showId: String) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users/\(uid)/shows").document("\(showId)").setData([
        "currentSeason": newSeason
    ], merge: true)
}

func updateRating(rating: Rating, showId: String) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users/\(uid)/shows").document("\(showId)").setData([
        "rating": rating.rawValue
    ], merge: true)
}

func updateShowCurrentlyAiring(currentlyAiringCurrentValue: Bool, showId: String) {
    Firestore.firestore().collection("shows").document("\(showId)").updateData([
        "currentlyAiring": !currentlyAiringCurrentValue
    ])
}

func deleteShowFromUserShows(showId: String) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users/\(uid)/shows").document("\(showId)").delete()
}

func deleteRatingFromUserShows(showId: String) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users/\(uid)/shows").document("\(showId)").updateData([
        "rating": FieldValue.delete()
    ])
}

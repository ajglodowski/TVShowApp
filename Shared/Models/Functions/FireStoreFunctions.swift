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
    }
    
    if (show.actors != nil && !show.actors!.isEmpty) {
        //print("Actor dict: \(show.actors!)\n")
        output["actors"] = show.actors
    }
    
    var stringStatusCounts = [String:Int]()
    for (key, value) in show.statusCounts {
        stringStatusCounts[key.rawValue] = value
    }
    output["statusCounts"] = stringStatusCounts
    
    var stringRatingCounts = [String:Int]()
    for (key, value) in show.ratingCounts {
        stringRatingCounts[key.rawValue] = value
    }
    output["ratingCounts"] = stringRatingCounts
    
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

func addToUserShows(show: Show) {
    let uid = Auth.auth().currentUser!.uid
    let showData = convertUserShowToDictionary(show: show)
    Firestore.firestore().collection("users/\(uid)/shows").document("\(show.id)").setData(showData) { err in
        if let err = err {
            print("Error writing document: \(err)")
        }
    }
    incrementStatusCount(showId: show.id, status: show.status!)
}

// Updating show properties in the current user's show collection
func updateToShows(show: Show, showNameEdited: Bool) {
    if (showNameEdited && show.actors != nil) {
        for (actorID, _) in show.actors! {
            Firestore.firestore().collection("actors").document(actorID).updateData([
                "shows.\(show.id)": show.name
            ])
        }
    }
    let showData = convertShowToDictionary(show: show)
    Firestore.firestore().collection("shows").document("\(show.id)").setData(showData)
}

func updateUserShow(show: Show) {
    let uid = Auth.auth().currentUser!.uid
    let showData = convertUserShowToDictionary(show: show)
    Firestore.firestore().collection("users/\(uid)/shows").document("\(show.id)").setData(showData) { err in
        if let err = err {
            print("Error writing document: \(err)")
        }
    }
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

func updateActor(act: Actor, actorNameEdited: Bool) {
    if (actorNameEdited) {
        for (showId, _) in act.shows {
            Firestore.firestore().collection("shows").document(showId).updateData([
                "actors.\(act.id)": act.name
            ])
        }
    }
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

func addActorToShow(act: Actor, showId: String) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "actors.\(act.id)": act.name
    ])
    Firestore.firestore().collection("actors").document(act.id).updateData([
        "shows.\(showId)": FieldValue.delete()
    ])
}

func removeActorFromShow(actorId: String, showId: String) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "actors.\(actorId)": FieldValue.delete()
    ])
    Firestore.firestore().collection("actors").document(actorId).updateData([
        "shows.\(showId)": FieldValue.delete()
    ])
    
}

func incrementTotalSeasons(showId: String) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "totalSeasons": FieldValue.increment(Int64(1))
    ])
}

func decrementRatingCount(showId: String, rating: Rating) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "ratingCounts.\(rating.rawValue)": FieldValue.increment(Int64(-1))
    ])
}

func incrementRatingCount(showId: String, rating: Rating) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "ratingCounts.\(rating.rawValue)": FieldValue.increment(Int64(1))
    ])
}

func decrementStatusCount(showId: String, status: Status) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "statusCounts.\(status.rawValue)": FieldValue.increment(Int64(-1))
    ])
}

func incrementStatusCount(showId: String, status: Status) {
    Firestore.firestore().collection("shows").document(showId).updateData([
        "statusCounts.\(status.rawValue)": FieldValue.increment(Int64(1))
    ])
}

func syncRatingCounts(showList: [Show]) {
    for show in showList {
        for rating in Rating.allCases {
            if (show.rating != nil && show.rating == rating) {
                Firestore.firestore().collection("shows").document(show.id).updateData([
                    "ratingCounts.\(rating.rawValue)": 1
                ])
            } else {
                Firestore.firestore().collection("shows").document(show.id).updateData([
                    "ratingCounts.\(rating.rawValue)": 0
                ])
            }
        }
    }
}

func syncStatusCounts(showList: [Show]) {
    for show in showList {
        for status in Status.allCases {
            if (show.status != nil && show.status == status) {
                Firestore.firestore().collection("shows").document(show.id).updateData([
                    "statusCounts.\(status.rawValue)": 1
                ])
            } else {
                Firestore.firestore().collection("shows").document(show.id).updateData([
                    "statusCounts.\(status.rawValue)": 0
                ])
            }
        }
    }
}

func refreshAgolia() {
    let db = Firestore.firestore()
    db.collection("shows").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    Firestore.firestore().collection("shows").document(document.documentID).updateData([
                        "statusCounts.Catching Up": FieldValue.increment(Int64(1))
                    ])
                    Firestore.firestore().collection("shows").document(document.documentID).updateData([
                        "statusCounts.Catching Up": FieldValue.increment(Int64(-1))
                    ])
                }
            }
    }
}
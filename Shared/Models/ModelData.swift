//
//  ModelData.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import Foundation
import Combine
import SwiftUI
import Firebase

final class ModelData : ObservableObject {
    
    @Published var loadedShow: Show? = nil
    
    @Published var entered: Bool = false

    var shows: [Show] { Array(showDict.values) }
    @Published var showDict = [String:Show]()
    @Published var loadingShows: Set<String> = Set<String>()
    @Published var fullShowImages: [String:UIImage] = [String:UIImage]()

    @Published var loadedActors = [String: Actor]()
    
    var computedActors: [String:Actor] {
        var output = [String:Actor]()
        for show in self.shows {
            if (show.actors != nil) {
                for (actorId, actorName) in show.actors! {
                    if (output[actorId] != nil) { output[actorId]!.shows[show.id] = show.name }
                    else {
                        var a = Actor(id: actorId)
                        a.name = actorName
                        a.shows[show.id] = show.name
                        output[actorId] = a
                    }
                }
            }
        }
        return output
    }
    var actorDict: [String:Actor] {
        return computedActors.merging(loadedActors) { (_, new) in new }
    }
    
    
    var actors: [Actor] { Array(actorDict.values) }
    
    @Published var currentUser: Profile? = nil
    
    @Published var updateDict = [String:UserUpdate]()
    var currentUserUpdates: [UserUpdate] {
        if (currentUser != nil) { return Array(updateDict.values).filter { $0.userId == currentUser!.id } }
        else { return [UserUpdate]() }
    }
    var lastFriendUpdates: [UserUpdate] {
        var output = [UserUpdate]()
        if (currentUser != nil) {
            let allFriendUpdates = Array(updateDict.values).filter { $0.userId != Auth.auth().currentUser!.uid }.sorted{ $0.updateDate > $1.updateDate }.sorted{ $0.userId < $1.userId }
            let friends = Array(Set(allFriendUpdates.map { $0.userId }))
            for friend in friends {
                output.append(allFriendUpdates.first(where: { $0.userId == friend })!)
            }
        }
        return output
    }
    @Published var tileImageCache: [String: Image] = [String: Image]()
    
    @Published var profiles: [String: Profile] = [String: Profile]()
    @Published var profilePics: [String: Image] = [String: Image]()
    @Published var loadingProfiles: Set<String> = Set<String>()
    
    @Published var needsUpdated: Bool = false
    
     var initialLoaded = false
    
    //private var ref: DatabaseReference = Database.database().reference()
    private let fireStore = Firebase.Firestore.firestore()
    
    var loggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    var showIds: [String] {
        shows.map { $0.id }
    }
    
    init() {
        // Disables caching
        /*
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        fireStore.settings = settings
        */
    
        // Resets cache
        //fireStore.clearPersistence()
        
        if (loggedIn && !initialLoaded) {
            loadCurrentUser()
            loadFromFireStore()
        } else {
            print("Not logged in")
        }
    }
    /*
    func initFireStore() {
        let settings = fireStore.settings
        settings.timeStamp = true
        fireStore.settings = settings
    }
     */
    
    func refreshData() {
        if (loggedIn) {
            loadCurrentUser() 
        }
        //loadCurrentUser()
        loadFromFireStore()
        //fetchActorsFromFirestore()
    }
    
    func fetchAllFromFireStore() {
        let keys = Array(self.showDict.keys).sorted { $0 < $1 }
        for key in keys {
            let dbDoc = fireStore.collection("shows").document(key)
            dbDoc.getDocument { document, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()!
                    let userSpecificData = self.showDict[key]!
                    let showData = convertShowDictToShow(showId: key, data: data)
                    var combined = mergeShowTypes(userData: userSpecificData, showData: showData)
                    combined.partiallyLoaded = false
                    self.showDict[key] = combined
                    
                    if (key == keys.last) {
                        //self.fetchActorsFromFirestore()
                        self.loadCurrentUserUpdates()
                    }
                }
            }
        }
    }
    
    func loadFromFireStore() {
        let uid = Auth.auth().currentUser!.uid
        let show = fireStore.collection("users/\(uid)/shows")
        show.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let showId = document.documentID
                    var personalizedShow = Show(id: showId)
                
                    let status = data["status"] as! String
                    let currentSeason = data["currentSeason"] as! Int
                    let rating = data["rating"] as? String // No rating is allowed
                    
                    var userSpecificValues = ShowUserSpecificValues(status: Status(rawValue: status)!, currentSeason: currentSeason)
                    if (rating != nil) { userSpecificValues.rating = Rating(rawValue: rating!) }
                    else { userSpecificValues.rating = nil }
                    
                    let updates = self.currentUserUpdates.filter { $0.showId == personalizedShow.id }
                    userSpecificValues.currentUserUpdates = updates
                    
                    personalizedShow.userSpecificValues = userSpecificValues
                    personalizedShow.partiallyLoaded = true
                    
                    self.showDict[showId] = personalizedShow
                }
                self.fetchAllFromFireStore() // Other Loading
            }
        }
    }
    /*
    // 01/18/2023 Switched to computed property
    func fetchActorsFromFirestore() {
        for show in self.shows {
            if (show.actors != nil) {
                for (actorId, actorName) in show.actors! {
                    if (self.actorDict[actorId] != nil) { self.actorDict[actorId]!.shows[show.id] = show.name }
                    else {
                        var a = Actor(id: actorId)
                        a.name = actorName
                        a.shows[show.id] = show.name
                        self.actorDict[actorId] = a
                    }
                }
            }
        }
        print("Done loading actors")
    }
     */
    
    func loadCurrentUser() {
        let uid = Auth.auth().currentUser!.uid
        let show = fireStore.collection("users").document(uid)
        
        show.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                let optData = snapshot.data()
                if (optData == nil) {
                    print("Error loading current user")
                    return
                }
                let data = optData!
                let add = convertProfileDictToProfile(profileId: uid, data: data)
                self.currentUser = add
                
                self.loadLatestFriendUpdates()
            }
        }
    }
    
    func loadCurrentUserUpdates() { // Loading the only the latest updates for shows
        let uid = Auth.auth().currentUser!.uid
        let keys = Array(self.showDict.keys).sorted { $0 < $1 }
        for key in keys { // Go through the users shows
            let dbDoc = fireStore.collection("updates").whereField("showId", isEqualTo: key).whereField("userId", isEqualTo: uid).order(by: "updateDate", descending: true).limit(to: 1) // Find latest update for a user's show
            dbDoc.getDocuments { querySnapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let updateId = document.documentID
                    let update = convertDataDictToUserUpdate(updateId: updateId, data: data)
                    let showId = update.showId
                    if (self.showDict[showId]!.userSpecificValues!.currentUserUpdates != nil) { self.showDict[showId]!.userSpecificValues!.currentUserUpdates!.append(update) }
                    else { self.showDict[showId]!.userSpecificValues!.currentUserUpdates = [update] }
                    
                    self.updateDict[updateId] = update
                    
                }
            }
        }
        
    }
    
    func loadLatestFriendUpdates() {
        if (self.currentUser == nil) { print("User null") }
        let friends = Array(self.currentUser!.following.map { $0.keys }!)
        for friend in friends {
            let updates = fireStore.collection("updates").whereField("userId", isEqualTo: friend).order(by: "updateDate", descending: true).limit(to: 1)
            updates.addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let updateId = document.documentID
                        //if (self.lastFriendUpdates.contains(where: {$0.id == updateId})) { continue } // prevent double appending
                        let data = document.data()
                        let update = convertDataDictToUserUpdate(updateId: updateId, data: data)
                        //self.lastFriendUpdates.append(update)
                        self.updateDict[updateId] = update
                    }
                }
            }
        }
        
    }
    
    /*
    func convertFromRealtime() {
        var addedActors = [String:String]() // Name:ID
        for show in self.shows {
            let actors = getActors(showIn: show, actors: self.actors)
            var actorDict = [String:String]()
            for act in actors {
                var actorId = ""
                if (addedActors[act.name] == nil) {
                    actorId = addActorToActors(act: act)
                    addedActors[act.name] = actorId
                } else {
                    actorId = addedActors[act.name]!
                }
                actorDict[actorId] = act.name
            }
            var addShow = show
            addShow.actors = actorDict
            let showId = addToShows(show: addShow)
            addShow.id = showId
            addOrUpdateToUserShows(show: addShow)
            
        }
    }
     */
     
    
    
    
    
}



extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

public extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

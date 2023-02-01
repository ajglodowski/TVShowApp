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
                    var add = self.showDict[key]!
                    
                    let name = data["name"] as! String
                    let running = data["running"] as! Bool
                    let totalSeasons = data["totalSeasons"] as! Int
                    let tags = data["tags"] as? [String] ?? [String]()
                    let currentlyAiring = data["currentlyAiring"] as? Bool ?? false
                    let service = data["service"] as! String
                    let limitedSeries = data["limitedSeries"] as! Bool
                    let length = data["length"] as! String
                    
                    let releaseDate = data["releaseDate"] as? Timestamp
                    let airdate = data["airdate"] as? String
                    
                    let actors = data["actors"] as? [String: String]
                    let statusCounts = data["statusCounts"] as! [String: Int]
                    let ratingCounts = data["ratingCounts"] as! [String: Int]
                    
                    var tagArray = [Tag]()
                    for tag in tags {
                        tagArray.append(Tag(rawValue: tag)!)
                    }
                    
                    add.name = name
                    add.running = running
                    add.totalSeasons = totalSeasons
                    add.tags = tagArray
                    add.currentlyAiring = currentlyAiring
                    add.service = Service(rawValue: service)!
                    add.limitedSeries = limitedSeries
                    add.length = ShowLength(rawValue: length)!
                    if (airdate != nil) { add.airdate = AirDate(rawValue: airdate!) }
                    add.releaseDate = releaseDate?.dateValue()
                    if (actors != nil) { add.actors = actors }
                    for (key, value) in statusCounts {
                        add.statusCounts[Status(rawValue: key)!] = value
                    }
                    for (key, value) in ratingCounts {
                        add.ratingCounts[Rating(rawValue: key)!] = value
                    }
                    self.showDict[add.id] = add
                    
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
                    
                    personalizedShow.status = Status(rawValue: status)
                    personalizedShow.currentSeason = currentSeason
                    if (rating != nil) { personalizedShow.rating = Rating(rawValue: rating!) }
                    else { personalizedShow.rating = nil }
                    
                    let updates = self.currentUserUpdates.filter { $0.showId == personalizedShow.id }
                    personalizedShow.currentUserUpdates = updates
                    
                    //self.shows.append(personalizedShow)
                    self.showDict[showId] = personalizedShow
                }
                self.fetchAllFromFireStore() // Other Loading
                //self.loadCurrentUserUpdates()
                //self.loadLatestFriendUpdates()
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
                if (optData == nil) { return }
                let data = optData!
                    
                let username = data["username"] as! String
                var profilePhotoURL = data["profilePhotoURL"] as? String
                let bio = data["bio"] as? String
                let showCount = data["showCount"] as! Int
                
                let followingCount = data["followingCount"] as! Int
                let followerCount = data["followerCount"] as! Int
                let followers = data["followers"] as? [String:String]
                let following = data["following"] as? [String:String]
                let showLists = data["showLists"] as? [String]
                let likedShowLists = data["likedShowLists"] as? [String]
                
                let pinnedShows =  data["pinnedShows"] as? [String:String]
                let pinnedShowCount = data["pinnedShowCount"] as? Int ?? 0
                
                let add = Profile(id: uid, username: username, profilePhotoURL: profilePhotoURL, bio: bio, pinnedShows: pinnedShows, pinnedShowCount: pinnedShowCount, showCount: showCount, followingCount: followingCount, followerCount: followerCount, followers: followers, following: following, showLists: showLists, likedShowLists: likedShowLists)
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
                    let showId = data["showId"] as! String
                
                    let updateDate = data["updateDate"] as! Timestamp
                    let updateType = data["updateType"] as! String
                    
                    let seasonChange = data["seasonChange"] as? Int // Type specific values
                    let statusChangeRaw = data["statusChange"] as? String
                    let ratingChangeRaw = data["ratingChange"] as? String
                    let statusChange = (statusChangeRaw != nil) ? Status(rawValue: statusChangeRaw!) : nil
                    let ratingChange = (ratingChangeRaw != nil) ? Rating(rawValue: ratingChangeRaw!) : nil
                    
                    let update = UserUpdate(id: updateId, userId: uid, showId: showId, updateType: UserUpdateCategory(rawValue: updateType)!, updateDate: updateDate.dateValue(), statusChange: statusChange, seasonChange: seasonChange, ratingChange: ratingChange)
                    if (self.showDict[showId]!.currentUserUpdates != nil) { self.showDict[showId]!.currentUserUpdates!.append(update) }
                    else { self.showDict[showId]!.currentUserUpdates = [update] }
                    
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
                        let showId = data["showId"] as! String
                        let updateDate = data["updateDate"] as! Timestamp
                        let updateType = data["updateType"] as! String
                        
                        let seasonChange = data["seasonChange"] as? Int // Type specific values
                        let statusChangeRaw = data["statusChange"] as? String
                        let ratingChangeRaw = data["ratingChange"] as? String
                        let statusChange = (statusChangeRaw != nil) ? Status(rawValue: statusChangeRaw!) : nil
                        let ratingChange = (ratingChangeRaw != nil) ? Rating(rawValue: ratingChangeRaw!) : nil
                        
                        let update = UserUpdate(id: updateId, userId: friend, showId: showId, updateType: UserUpdateCategory(rawValue: updateType)!, updateDate: updateDate.dateValue(), statusChange: statusChange, seasonChange: seasonChange, ratingChange: ratingChange)
                        //self.lastFriendUpdates.append(update)
                        self.updateDict[updateId] = update
                    }
                }
            }
        }
        
    }
     
    
    /*
    // If more data from actors is added use this instead but otherwise this is too many reads
    func fetchActorsFromFirestore() {
        let shows = fireStore.collection("actors")
        shows.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                var output = [Actor]()
                for document in snapshot.documents {
                    let data = document.data()
                    //print(data)
                    
                    var add = Actor(id: document.documentID)
                    
                    let name = data["actorName"] as! String
                    let shows = data["shows"] as? [String:String] ?? [String:String]()
                    
                    add.name = name
                    add.shows = shows
                    output.append(add)
                }
                print("Actor Count: \(output.count)")
                self.loadActorsFromFireStore(actors: output)
            }
        }
    }
     */
    
     
    
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

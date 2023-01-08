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

    //@Published var shows: [Show] = load("showData.json")
    //@Published var shows: [Show] = load("data.json")
    //@Published var shows = [Show]()
    var shows: [Show] { Array(showDict.values) }
    @Published var showDict = [String:Show]()
    //@Published var otherShows = [Show]()
    //@Published var shows: [Show] = loadFromFile("data.json")
    //@Published var actors: [Actor] = loadFromFile("actorData.json")
    //@Published var actors: [Actor] = load("actorData.json")
    @Published var actors = [Actor]()
    @Published var currentUser: Profile? = nil
    @Published var currentUserUpdates = [UserUpdate]()
    @Published var lastFriendUpdates = [UserUpdate]()
    @Published var tileImageCache: [String: Image] = [String: Image]()
    
    @Published var needsUpdated: Bool = false
    
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
        
        if (loggedIn) {
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
        fetchActorsFromFirestore()
    }
    
    func fetchAllFromFireStore() {
        let keys = Array(self.showDict.keys)
        let chunkSize = 10
        let chunks = stride(from: 0, to: keys.count, by: chunkSize).map {
            Array(keys[$0..<min($0 + chunkSize, keys.count)])
        }
        for chunk in chunks {
            let dbChunk = fireStore.collection("shows").whereField(FieldPath.documentID(), in: chunk)
            dbChunk.addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        let data = doc.data()
                        var add = self.showDict[doc.documentID]!
                        
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
                    }
                    if (chunk == chunks.last) {
                        self.fetchActorsFromFirestore()
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
    
    func loadActorsFromFireStore(actors: [Actor]) { self.actors = actors}
    
    func fetchActorsFromFirestore() {
        var output = [Actor]()
        for show in self.shows {
            if (show.actors != nil) {
                for (actorId, actorName) in show.actors! {
                    let found = output.firstIndex(where: {$0.id == actorId})
                    if (found != nil) { output[found!].shows[show.id] = show.name }
                    else {
                        var a = Actor(id: actorId)
                        a.name = actorName
                        a.shows[show.id] = show.name
                        output.append(a)
                    }
                }
            }
        }
        //print("Output: \(output)")
        loadActorsFromFireStore(actors: output)
        //print("Actors: \(self.actors)")
    }
    
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
                
                self.loadCurrentUserUpdates()
                self.loadLatestFriendUpdates()
            }
        }
    }
    
    func loadCurrentUserUpdates() {
        let uid = Auth.auth().currentUser!.uid
        let updates = fireStore.collection("updates").whereField("userId", isEqualTo: uid)
        updates.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let updateId = document.documentID
                    if (self.currentUserUpdates.contains(where: {$0.id == updateId})) { continue } // prevent double appending
                    let data = document.data()
                    let showId = data["showId"] as! String
                    let entireIndex = self.shows.firstIndex(where: { $0.id == showId})!
                
                    let updateDate = data["updateDate"] as! Timestamp
                    let updateType = data["updateType"] as! String
                    
                    let seasonChange = data["seasonChange"] as? Int // No update date is allowed
                    let statusChangeRaw = data["statusChange"] as? String // No update date is allowed
                    var statusChange: Status? = nil
                    if (statusChangeRaw != nil) { statusChange = Status(rawValue: statusChangeRaw!) }
                    
                    let update = UserUpdate(id: updateId, userId: uid, showId: showId, updateType: UserUpdateCategory(rawValue: updateType)!, updateDate: updateDate.dateValue(), statusChange: statusChange, seasonChange: seasonChange)
                    //if (self.shows[entireIndex].currentUserUpdates != nil) { self.shows[entireIndex].currentUserUpdates!.append(update) }
                    if (self.showDict[showId]!.currentUserUpdates != nil) { self.showDict[showId]!.currentUserUpdates!.append(update) }
                    else { self.showDict[showId]!.currentUserUpdates = [update] }
                    //print(self.shows[entireIndex].currentUserUpdates?.count)
                    self.currentUserUpdates.append(update)
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
                        if (self.lastFriendUpdates.contains(where: {$0.id == updateId})) { continue } // prevent double appending
                        let data = document.data()
                        let showId = data["showId"] as! String
                        let updateDate = data["updateDate"] as! Timestamp
                        let updateType = data["updateType"] as! String
                        
                        let seasonChange = data["seasonChange"] as? Int // No update date is allowed
                        let statusChangeRaw = data["statusChange"] as? String // No update date is allowed
                        var statusChange: Status? = nil
                        if (statusChangeRaw != nil) { statusChange = Status(rawValue: statusChangeRaw!) }
                        
                        let update = UserUpdate(id: updateId, userId: friend, showId: showId, updateType: UserUpdateCategory(rawValue: updateType)!, updateDate: updateDate.dateValue(), statusChange: statusChange, seasonChange: seasonChange)
                        self.lastFriendUpdates.append(update)
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

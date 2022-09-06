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
    @Published var shows = [Show]()
    //@Published var otherShows = [Show]()
    //@Published var shows: [Show] = loadFromFile("data.json")
    //@Published var actors: [Actor] = loadFromFile("actorData.json")
    //@Published var actors: [Actor] = load("actorData.json")
    @Published var actors = [Actor]()
    @Published var currentUser: Profile? = nil
    
    @Published var needsUpdated: Bool = false
    
    //private var ref: DatabaseReference = Database.database().reference()
    private let fireStore = Firebase.Firestore.firestore()
    
    var loggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    init() {
        /*
        // Disables caching
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        fireStore.settings = settings
        */
        
        
        // Resets cache
        //fireStore.clearPersistence()
        
        
        //firebaseShowFetch()
        //firebaseActorFetch()
        if (loggedIn) {
            loadCurrentUser()
        }
        //loadCurrentUser()
        fetchAllFromFireStore()
        /*
        if (loggedIn) {
            loadFromFireStore()
        }
         */
        //fetchActorsFromFirestore()
         
        
    }
    /*
    func initFireStore() {
        let settings = fireStore.settings
        settings.timeStamp = true
        fireStore.settings = settings
    }
     */
    
    func refreshData() {
        //self.shows = load("data.json")
        //firebaseShowFetch()
        //firebaseActorFetch()
        //self.actors = load("actorData.json")
        //self.shows = loadFromFile("data.json")
        //self.actors = loadFromFile("actorData.json")
        if (loggedIn) {
            loadCurrentUser() 
        }
        //loadCurrentUser()
        loadFromFireStore()
        fetchActorsFromFirestore()
    }
    
    
        
    /*
    func loadBasicShow(showId: String) -> Int {
        var showIndex = -1
        let shows = fireStore.collection("shows/\(showId)")
        shows.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    var add = Show(id: document.documentID)
                    
                    let name = data["name"] as? String ?? ""
                    let running = data["running"] as? Bool ?? false
                    let totalSeasons = data["totalSeasons"] as? Int ?? 1
                    
                    let service = data["service"] as? String ?? ""
                    let limitedSeries = data["limitedSeries"] as? Bool ?? false
                    let length = data["showLength"] as? String ?? ""
                    
                    let releaseDate = data["releaseDate"] as? Date
                    let airdate = data["airDate"] as? String
                    
                    
                    add.name = name
                    add.running = running
                    add.totalSeasons = totalSeasons
                    add.service = Service(rawValue: service)!
                    add.limitedSeries = limitedSeries
                    add.length = ShowLength(rawValue: length)!
                    if (airdate != nil) { add.airdate = AirDate(rawValue: airdate!) }
                    if (releaseDate != nil) { add.releaseDate = releaseDate }
                    print(add)
                    self.shows.append(add)
                    
                    showIndex = self.shows.firstIndex(of: add)!
                    
                    // Tag fetching
                    let tags = self.fireStore.collection("shows/\(document.documentID)/tags")
                    tags.getDocuments { s1, e1 in
                        if let s1 = s1 {
                            for d1 in s1.documents {
                                let tagData = d1.data()
                                let tagString = tagData["tagName"] as? String ?? ""
                                let tag = Tag(rawValue: tagString)!
                                self.shows[showIndex].tags.append(tag)
                            }
                        }
                    }
                    
                    // Actor Fetching
                    let actorCollection = self.fireStore.collection("shows/\(document.documentID)/actors")
                    actorCollection.getDocuments { s4, e4 in
                        if let s4 = s4 {
                            for d4 in s4.documents {
                                let actorData = d4.data()
                                let actorName = actorData["actorName"] as? String ?? ""
                                let actorId = actorData["actorId"] as? String ?? ""
                                self.shows[showIndex].actors = [String:String]()
                                self.shows[showIndex].actors![actorId] = actorName
                            }
                        }
                    }
                    
                }
            }
        }
        return showIndex
    }
     */
    
    func loadAllShowsFromFireStore(load: [Show]) { self.shows = load}
    //func loadUserShowsFromFireStore(load: [Show]) { self.shows = load }
    
    func fetchAllFromFireStore() {
        let shows = fireStore.collection("shows")
        shows.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                var output = [Show]()
                for document in snapshot.documents {
                    let data = document.data()
                    //print(data)
                    
                    var add = Show(id: document.documentID)
                    
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
                    for (key, value) in ratingCounts {
                        add.ratingCounts[Rating(rawValue: key)!] = value
                    }
                    output.append(add)
                    
                }
                //self.loadAllShowsFromFireStore(load: output)
                self.shows = output
                if (Auth.auth().currentUser != nil) {
                    self.loadFromFireStore()
                }
                self.fetchActorsFromFirestore()
            }
        }
    }
    
    func loadFromFireStore() {
        let uid = Auth.auth().currentUser!.uid
        //print("UID: \(uid)")
        let show = fireStore.collection("users/\(uid)/shows")
        show.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                //var output = [Show]()
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let showId = document.documentID
                    let entireIndex = self.shows.firstIndex(where: { $0.id == showId})!
                    var personalizedShow = self.shows[entireIndex]
                
                    let status = data["status"] as! String
                    let currentSeason = data["currentSeason"] as! Int
                    let rating = data["rating"] as? String // No rating is allowed
                    
                    personalizedShow.status = Status(rawValue: status)
                    personalizedShow.currentSeason = currentSeason
                    if (rating != nil) { personalizedShow.rating = Rating(rawValue: rating!) }
                    else { personalizedShow.rating = nil }
                    
                    self.shows[entireIndex] = personalizedShow
                }
                //self.loadUserShowsFromFireStore(load: output)
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
                
                let pinnedShows =  data["pinnedShows"] as? [String:String]
                let pinnedShowCount = data["pinnedShowCount"] as? Int ?? 0
                let add = Profile(id: uid, username: username, profilePhotoURL: profilePhotoURL, bio: bio, pinnedShows: pinnedShows, pinnedShowCount: pinnedShowCount, showCount: showCount, followingCount: followingCount, followerCount: followerCount, followers: followers, following: following)
                self.currentUser = add
                
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

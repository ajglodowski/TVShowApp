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
    
    @Published var loggedIn = false
    //@Published var shows: [Show] = load("showData.json")
    //@Published var shows: [Show] = load("data.json")
    @Published var shows = [Show]()
    //@Published var otherShows = [Show]()
    //@Published var shows: [Show] = loadFromFile("data.json")
    //@Published var actors: [Actor] = loadFromFile("actorData.json")
    //@Published var actors: [Actor] = load("actorData.json")
    @Published var actors = [Actor]()
    
    @Published var needsUpdated: Bool = false
    
    private var ref: DatabaseReference = Database.database().reference()
    private let fireStore = Firebase.Firestore.firestore()
    
    
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
        loadFromFireStore()
        fetchActorsFromFirestore()
    }
    
    func saveData() {
        //save("data.json",true)
        //firebaseShowSave()
        //firebaseActorSave()
        //save("actorData.json",false)
    }
    
    
    func save(_ filename: String, _ savingsShows: Bool) {
        
        // Use for deploy on device
        /*
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("new.json")
         
        
        // Saving doesn't work locally but this allows previews
        guard let fileUrl = Bundle.main.url(forResource: "csvjson.json", withExtension: nil) else { fatalError("Error in path") }
        
        guard let data = try? JSONEncoder().encode(shows) else { fatalError("Error encoding data") }
        do {
            try data.write(to: fileUrl)
        } catch {
            fatalError("Can't write to file")
        }
         */
        //print("Here")
        
        
        var sha = ""
        let getUrl = URL(string: "https://api.github.com/repos/ajglodowski/TVShowApp/contents/"+filename)!
        let sema = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: getUrl) { (data, response, error) in
            guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do {
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                guard let jNew = jsonResponse as? [String:Any] else { print("error in get response"); return}
                let tempSha = jNew["sha"] as! String
                sha = tempSha
                //print("setting sha"+sha)
             } catch let parsingError {
                print("Error")
           }
        }
        task.resume()
        let timeOut : Double = 1.0
        sema.wait(timeout: DispatchTime.now()+timeOut)
        
        let token = "token " + Hidden.token
        let repo = "https://api.github.com/repos/ajglodowski/TVShowApp/contents/"+filename
        let url = URL(string: repo)!
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Authorization": token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        //guard var data = try! JSONSerialization.data(withJSONObject: shows, options: .prettyPrinted)
        var data : Data
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if (savingsShows) {
            guard var d = try? encoder.encode(shows) else { fatalError("Error encoding data") }
            data = d
        } else {
            guard var d = try? encoder.encode(actors) else { fatalError("Error encoding data") }
            data = d
        }
        data = data.base64EncodedData()
        let sData = String(decoding: data, as: UTF8.self)
        let jsonMessage : [String:String] = ["sha": sha,
            "message": "Updating show data",
            "content": sData
        ]
        let dBody = jsonMessage.description
        guard let dBodyD = try? JSONEncoder().encode(jsonMessage) else { fatalError("Error encoding data") }
        
        request.httpBody = dBodyD
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            guard let responseData = responseData, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Error in json response")
            }
        }.resume()
                    
    }
    
    func loadShowsFromFirebase(input: [Show]) { self.shows = input }
    func loadActorsFromFirebase(input: [Actor]) { self.actors = input }

    func firebaseShowFetch() {
        self.ref.child("shows").getData(completion:  { error, snapshot in
              guard error == nil else {
                print(error!.localizedDescription)
                return;
              }
            //snapshot.value(as: [Show])
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot?.value as Any, options: []) else { return }
            //print(data)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let out = try! decoder.decode([Show].self, from: data)
            self.loadShowsFromFirebase(input: out)
        });
    }
    
    func firebaseActorFetch() {
        self.ref.child("actors").getData(completion:  { error, snapshot in
              guard error == nil else {
                print(error!.localizedDescription)
                return;
              }
            //snapshot.value(as: [Show])
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot?.value as Any, options: []) else { return }
            //print(data)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let out = try! decoder.decode([Actor].self, from: data)
            self.loadActorsFromFirebase(input: out)
        });
    }
    
    func firebaseShowSave() {
        /*
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard var data = try? encoder.encode(self.shows) else { fatalError("Error encoding data") }
        let jsonString = String(data: data, encoding: .utf8)!
        print(jsonString)
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("shows").setValue(jsonString)
        */
        let link = "https://tv-show-app-602d7-default-rtdb.firebaseio.com/shows.json"
        let url = URL(string: link)!
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard var data = try? encoder.encode(self.shows) else { fatalError("Error encoding data") }
        //let jsonString = String(data: data, encoding: .utf8)!
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            guard let responseData = responseData, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Error in json response")
            }
        }.resume()
    }
    
    func firebaseActorSave() {
        let link = "https://tv-show-app-602d7-default-rtdb.firebaseio.com/actors.json"
        let url = URL(string: link)!
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard var data = try? encoder.encode(self.actors) else { fatalError("Error encoding data") }
        //let jsonString = String(data: data, encoding: .utf8)!
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            guard let responseData = responseData, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Error in json response")
            }
        }.resume()
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

func load<T: Decodable>(_ filename: String) -> T {

    var data: Data
    
    var showsString = ""
    let urlString = "https://api.github.com/repos/ajglodowski/TVShowApp/contents/" + filename
    let getUrl = URL(string: urlString)!
    let sema = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: getUrl) { (data, response, error) in
        guard let dataResponse = data,
              error == nil else {
              print(error?.localizedDescription ?? "Response Error")
              return }
        do {
            //here dataResponse received from a network request
            let jsonResponse = try JSONSerialization.jsonObject(with:
                                   dataResponse, options: [])
            guard let jNew = jsonResponse as? [String:Any] else { print("error in get response"); return}
            let tempShows = jNew["content"] as! String
            showsString = tempShows
            //print("setting sha"+sha)
         } catch {
            print("Parsing Error")
       }
    }
    task.resume()
    let timeOut : Double = 2.0
    sema.wait(timeout: DispatchTime.now()+timeOut)
    data = Data(base64Encoded: showsString, options: .ignoreUnknownCharacters)!
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data);
    } catch {
        print("error in loading")
        print(error)
        fatalError("Couldn't parse as data")
    }
    
}


func loadFromFile<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else { fatalError("Error in path") }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
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

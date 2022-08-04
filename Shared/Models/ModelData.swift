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
    //@Published var shows: [Show] = load("showData.json")
    //@Published var shows: [Show] = load("data.json")
    @Published var shows = [Show]()
    //@Published var shows: [Show] = loadFromFile("data.json")
    //@Published var actors: [Actor] = loadFromFile("actorData.json")
    //@Published var actors: [Actor] = load("actorData.json")
    @Published var actors = [Actor]()
    
    @Published var needsUpdated: Bool = false
    
    private var ref: DatabaseReference = Database.database().reference()
    
    init() {
        firebaseShowFetch()
        firebaseActorFetch()
    }
    
    func refreshData() {
        //self.shows = load("data.json")
        firebaseShowFetch()
        firebaseActorFetch()
        //self.actors = load("actorData.json")
        //self.shows = loadFromFile("data.json")
        //self.actors = loadFromFile("actorData.json")
    }
    
    func saveData() {
        //save("data.json",true)
        firebaseShowSave()
        firebaseActorSave()
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
    
    func addShow(show: Show) {
        let link = "https://tv-show-app-602d7-default-rtdb.firebaseio.com/shows.json"
        let url = URL(string: link)!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard var data = try? encoder.encode(show) else { fatalError("Error encoding data") }
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

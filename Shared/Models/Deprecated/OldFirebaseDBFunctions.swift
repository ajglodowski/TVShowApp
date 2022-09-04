//
//  OldFirebaseDBFunctions.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation

// Just using this for storage of old functions

/*
 
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
 
 */

//
//  ModelData.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import Foundation
import Combine

final class ModelData : ObservableObject {
    //@Published var shows: [Show] = load("showData.json")
    @Published var shows: [Show] = load()
    
    @Published var needsUpdated: Bool = false
    
    func refreshData() {
        self.shows = load()
    }
    
    
    func save() {
        
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
        
        // Need a request to get SHA but otherwise this works
        var sha = ""
        let getUrl = URL(string: "https://api.github.com/repos/ajglodowski/TVShowApp/contents/data.json")!
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
        let timeOut : Double = 0.5
        sema.wait(timeout: DispatchTime.now()+timeOut)
        //print("test"+sha)
        //let sha = getData["sha"]
        let token = "token " + Hidden.token
        let repo = "https://api.github.com/repos/ajglodowski/TVShowApp/contents/data.json"
        let url = URL(string: repo)!
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Authorization": token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        //guard var data = try! JSONSerialization.data(withJSONObject: shows, options: .prettyPrinted)
        guard var data = try? JSONEncoder().encode(shows) else { fatalError("Error encoding data") }
        data = data.base64EncodedData()
        let sData = String(decoding: data, as: UTF8.self)
        let jsonMessage : [String:String] = ["sha": sha,
            "message": "Updating show data",
            "content": sData
        ]
        let dBody = jsonMessage.description
        //print(dBody)
        guard let dBodyD = try? JSONEncoder().encode(jsonMessage) else { fatalError("Error encoding data") }
        //dBody = dBody.replacingCharacters(in: ...dBody.startIndex, with: "{")
        //dBody = dBody.replacingCharacters(in: ...dBody.index(before: dBody.endIndex), with: "}")
        //print(dBody)
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
    
}

func load<T: Decodable>() -> T {

    var data: Data
    
    
    // Use for deploy on device
    /*
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Error in path") }
    let file = documentDirectoryUrl.appendingPathComponent("new.json")
     */
     
    
    /*
    // Use for local
    guard let file = Bundle.main.url(forResource: "csvjson.json", withExtension: nil) else { fatalError("Error in path") }
    */
    
    // Loading from github
    //print("Loading Data")
    /*
    var dataString = ""
    let url = URL(string: "https://raw.githubusercontent.com/ajglodowski/TVShowApp/main/data.json")!
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: url) { d, response, error in
        guard
            error == nil,
            let d = d,
            let string = String(data: d, encoding: .utf8)
        else {
            print(error ?? "Unknown error")
            return
        }
        dataString = string
        semaphore.signal()
    }
    task.resume()
    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    //print(dataString)
    data = dataString.data(using: .utf8)!
    */
    var showsString = ""
    let getUrl = URL(string: "https://api.github.com/repos/ajglodowski/TVShowApp/contents/data.json")!
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
    let timeOut : Double = 0.5
    sema.wait(timeout: DispatchTime.now()+timeOut)
    data = Data(base64Encoded: showsString, options: .ignoreUnknownCharacters)!
    
    
     // For loading from a file
    /*
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load file")
    }
     */
     
    

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data);
    } catch {
        print("error in loading")
        print(error)
        fatalError("Couldn't parse as data")
    }
    
}


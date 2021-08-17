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
    
    
    func saveToJsonFile() {
        
        // Use for deploy on device
        /*
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("new.json")
         */
         
         
        
        // Saving doesn't work locally but this allows previews
        guard let fileUrl = Bundle.main.url(forResource: "csvjson.json", withExtension: nil) else { fatalError("Error in path") }

        
        guard let data = try? JSONEncoder().encode(shows) else { fatalError("Error encoding data") }
        do {
            try data.write(to: fileUrl)
        } catch {
            fatalError("Can't write to file")
        }
        
    }
    
}

func load<T: Decodable>() -> T {

    let data: Data

    // Use for deploy on device
    /*
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Error in path") }
    let file = documentDirectoryUrl.appendingPathComponent("new.json")
     */
 
     
    // Use for local
    guard let file = Bundle.main.url(forResource: "csvjson.json", withExtension: nil) else { fatalError("Error in path") }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load file")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print(error)
        fatalError("Couldn't parse as data")
    }
}


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
        
        //guard let shows = self?.shows else { fatalError("Self out of scope") }
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("new.json")
        //guard let fileUrl = Bundle.main.url(forResource: "new.json", withExtension: nil) else { fatalError("file issue") }
        //fatalError(fileUrl.absoluteString)
        //let fileUrl = fileURL("new.json")

        
        guard let data = try? JSONEncoder().encode(shows) else { fatalError("Error encoding data") }
        do {
            try data.write(to: fileUrl)
        } catch {
            fatalError("Can't write to file")
        }
        
    }
    
}

func load<T: Decodable>() -> T {
    
    //fatalError("Hehe")
    let data: Data

    //guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Error in path") }
    let file = documentDirectoryUrl.appendingPathComponent("new.json")

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load file")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse as data")
    }
}


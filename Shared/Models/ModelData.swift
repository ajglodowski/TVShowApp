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
    @Published var shows: [Show] = load("convertcsv-2.json")
    
    @Published var needsUpdated: Bool = false
    //save(shows,"showData")
}

func load<T: Decodable>(_ filename: String) -> T {
    
    //fatalError("Hehe")
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


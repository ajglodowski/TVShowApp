//
//  ShowDetailViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ShowDetailViewModel: ObservableObject {
    
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func loadShow(modelData: ModelData, id: String) {
        if (modelData.loadingShows.contains(id)) { return }
        modelData.loadingShows.insert(id)
        print("Doing fetch for \(id)")
        let show = fireStore.collection("shows").document("\(id)")
        show.getDocument { document, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let document = document {
                let rawData = document.data()
                if (rawData == nil) {
                    print("Attempting to load show with invalid id")
                    return
                }
                let data = rawData!
                var add = convertShowDictToShow(showId: id, data: data)
                if (modelData.showDict[id] != nil) {
                    add = mergeShowTypes(userData: modelData.showDict[id]!, showData: add)
                }
                modelData.showDict[id] = add
                modelData.loadingShows.remove(id)
            }
        }
    }
    
}

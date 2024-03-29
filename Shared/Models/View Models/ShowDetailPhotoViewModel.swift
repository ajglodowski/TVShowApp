//
//  ShowDetailPhotoViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/13/22.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class ShowDetailPhotoViewModel: ObservableObject {
    
    @Published var showImage: UIImage? = nil
    
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    func loadImage(modelData: ModelData, showName: String) {
        let picRef = self.store.child("showImages/resizedImages/\(showName)_640x640.jpeg")
        picRef.getData(maxSize: 1 * 1024 * 1024) { data, error in // 1 MB Max
            if let error = error {
                if (!error.localizedDescription.contains("does not exist.")) {
                    print(error.localizedDescription)
                }
            } else {
                let profImage = UIImage(data: data!)!
                self.showImage = profImage
            }
        }
    }
    
    func loadImage(modelData: ModelData, show: Show) {
        if (modelData.fullShowImages[show.id] != nil) { return }
        let picRef = self.store.child("showImages/resizedImages/\(show.name)_640x640.jpeg")
        picRef.getData(maxSize: 1 * 1024 * 1024) { data, error in // 1 MB Max
            if let error = error {
                if (!error.localizedDescription.contains("does not exist.")) {
                    print(error.localizedDescription)
                }
            } else {
                let profImage = UIImage(data: data!)!
                modelData.fullShowImages[show.id] = profImage
                //self.showImage = profImage
            }
        }
    }
}


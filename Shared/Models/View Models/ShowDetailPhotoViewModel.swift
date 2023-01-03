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
    
    @MainActor
    func loadImage(showName: String) {
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
}


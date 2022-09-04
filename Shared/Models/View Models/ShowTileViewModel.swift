//
//  ShowTileViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ShowTileViewModel: ObservableObject {
    
    @Published var showImage: Image? = nil
    
    //private var ref: DatabaseReference = Database.database().reference()
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func loadImage(showName: String) {
        //fireStore.clearPersistence()
        // Loading Profile Pic
        let picRef = self.store.child("showImages/\(showName).jpg")
        picRef.getData(maxSize: 8 * 1024 * 1024) { data, error in // 2 MB
          if let error = error {
              if (!error.localizedDescription.contains("does not exist.")) {
                  print(error.localizedDescription)
              }
          } else {
              let profImage = UIImage(data: data!)!
              self.showImage = Image(uiImage: profImage)
          }
        }
    }
    
}

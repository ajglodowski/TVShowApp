//
//  ProfileViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    
    @Published var profile: Profile? = nil
    @Published var profilePic: Image? = nil
    
    //private var ref: DatabaseReference = Database.database().reference()
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func loadProfile(modelData: ModelData, id: String) {
        //fireStore.clearPersistence()
        if (modelData.profiles[id] != nil && modelData.profilePics[id] != nil) {
            self.profile = modelData.profiles[id]
            self.profilePic = modelData.profilePics[id]
            return
        }
        if (modelData.loadingProfiles.contains(id)) { return }
        modelData.loadingProfiles.insert(id)
        //print("Loading profile: \(id)")
        let show = fireStore.collection("users").document("\(id)")
        
        show.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                let optData = snapshot.data()
                if (optData == nil) { return }
                let data = optData!
                var add = convertProfileDictToProfile(profileId: id, data: data)
                self.profile = add
                modelData.profiles[id] = add
                // Loading Profile Pic
                if (add.profilePhotoURL == nil) { add.profilePhotoURL = "blank.jpg" }
                let picRef = self.store.child("profilePics/\(add.profilePhotoURL!)")
                picRef.getData(maxSize: 2 * 1024 * 1024) { data, error in // 2 MB
                  if let error = error {
                      print(error.localizedDescription)
                  } else {
                      let profImage = UIImage(data: data!)!
                      self.profilePic = Image(uiImage: profImage)
                      modelData.profilePics[id] = Image(uiImage: profImage)
                  }
                }
                
            }
        }
    }
    
}

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
    func loadProfile(id: String) {
        //fireStore.clearPersistence()
        let show = fireStore.collection("users").document("\(id)")
        
        show.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                let data = snapshot.data()
                let username = data!["username"] as! String
                let profilePhotoURL = data!["profilePhotoURL"] as! String
                let bio = data!["bio"] as! String
                let showCount = data!["showCount"] as! Int
                let lovedShows = [Show(id: "1085082")]
                let add = Profile(id: id, username: username, profilePhotoURL: profilePhotoURL, bio: bio, lovedShows: lovedShows, showCount: showCount)
                self.profile = add
                
                // Loading Profile Pic
                let picRef = self.store.child("profilePics/\(profilePhotoURL)")
                picRef.getData(maxSize: 2 * 1024 * 1024) { data, error in // 2 MB
                  if let error = error {
                      print(error.localizedDescription)
                  } else {
                      let profImage = UIImage(data: data!)!
                      self.profilePic = Image(uiImage: profImage)
                  }
                }
                
            }
        }
    }
    
}

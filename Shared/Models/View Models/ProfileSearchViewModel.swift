//
//  ProfileSearchViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ProfileSearchViewModel: ObservableObject {
    
    @Published var profilesReturned: [(Image, Profile)] = [(Image, Profile)]()
    
    //private var ref: DatabaseReference = Database.database().reference()
    //private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func searchForUser(username: String) {/*
        self.profilesReturned = [(Image, Profile)]()
        //var output = [(Image, Profile)]()
        let ref = fireStore.collection("users")
            //.whereField("username", isEqualTo: username)
            .whereField("username", isGreaterThanOrEqualTo: username)
            .whereField("username", isLessThanOrEqualTo: username)
            .limit(to: 3)
        ref.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            var add = convertProfileDictToProfile(profileId: document.documentID, data: data)
                            
                            // Loading Profile Pic
                            if (add.profilePhotoURL == nil) { add.profilePhotoURL = "blank.jpg" }
                            let picRef = self.store.child("profilePics/\(add.profilePhotoURL!)")
                            picRef.getData(maxSize: 2 * 1024 * 1024) { data, error in // 2 MB
                              if let error = error {
                                  print(error.localizedDescription)
                              } else {
                                  let profImage = Image(uiImage: UIImage(data: data!)!)
                                  let tup = (profImage, add)
                                  self.profilesReturned.append(tup)
                                  //print(tup)
                              }
                            }
                            
                            
                        }
                    }
            }
         */
    }
    
}

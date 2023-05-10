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
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func searchForUser(username: String) {
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
                            let username = data["username"] as! String
                            var profilePhotoURL = data["profilePhotoURL"] as? String
                            let bio = data["bio"] as? String
                            let showCount = data["showCount"] as! Int
                            let followingCount = data["followingCount"] as! Int
                            let followerCount = data["followerCount"] as! Int
                            let followers = data["followers"] as? [String:String]
                            let following = data["following"] as? [String:String]
                            let pinnedShows =  data["pinnedShows"] as? [String:String]
                            let pinnedShowCount = data["pinnedShowCount"] as? Int ?? 0
                            let add = Profile(id: document.documentID, username: username, profilePhotoURL: profilePhotoURL, bio: bio, pinnedShows: pinnedShows, pinnedShowCount: pinnedShowCount, showCount: showCount, followingCount: followingCount, followerCount: followerCount, followers: followers, following: following)
                            
                            // Loading Profile Pic
                            if (profilePhotoURL == nil) { profilePhotoURL = "blank.jpg" }
                            let picRef = self.store.child("profilePics/\(profilePhotoURL!)")
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
        /*
            
         */
    }
    
}

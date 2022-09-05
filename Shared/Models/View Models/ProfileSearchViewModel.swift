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
    
    @Published var profilesReturned: [(String, String)] = [(String, String)]()
    
    //private var ref: DatabaseReference = Database.database().reference()
    private var fireStore = Firebase.Firestore.firestore()
    
    @MainActor
    func searchForUser(username: String) {
        var output = [(String,String)]()
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
                            let add = (document.documentID, data["username"] as! String)
                            output.append(add)
                        }
                        //print(output)
                        self.profilesReturned = output
                    }
            }
        /*
            
         */
    }
    
}

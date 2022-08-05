//
//  FireStoreFunctions.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/4/22.
//

import Foundation
import Firebase

func addToUserShows(show: Show) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users/\(uid)/show").addDocument(data: [
        "showName": show.name,
        "service": show.service.rawValue,
        "status": show.status.rawValue,
        "showId": show.id
    ])
    
    
}

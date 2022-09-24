//
//  ShowListFunctions.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/23/22.
//

import Foundation
import Firebase

func incrementListLikeCount(listId: String) {
    Firestore.firestore().collection("lists").document(listId).updateData([
        "likeCount": FieldValue.increment(Int64(1))
    ])
}

func decrementListLikeCount(listId: String) {
    Firestore.firestore().collection("lists").document(listId).updateData([
        "likeCount": FieldValue.increment(Int64(-1))
    ])
}

func likeList(listId: String) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users").document(uid).updateData([
        "likedShowLists": FieldValue.arrayUnion([listId])
    ])
    incrementListLikeCount(listId: listId)
}

func dislikeList(listId: String) {
    let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users").document(uid).updateData([
        "likedShowLists": FieldValue.arrayRemove([listId])
    ])
    decrementListLikeCount(listId: listId)
}

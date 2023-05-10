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

func updateListShows(listId: String, showsAr: [Show]) {
    let showIds: [String] = showsAr.map { $0.id }
    Firestore.firestore().collection("lists").document(listId).updateData([
        "shows": showIds
    ])
}

func updateListOrdered(listId: String, listOrdered: Bool) {
    Firestore.firestore().collection("lists").document(listId).updateData([
        "ordered": listOrdered
    ])
}

func makeListPrivate(listId: String) {
    Firestore.firestore().collection("lists").document(listId).updateData([
        "priv": true
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func makeListPublic(listId: String) {
    Firestore.firestore().collection("lists").document(listId).updateData([
        "priv": false
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func addListToLists(list: ShowList) -> String {
    let listDict = convertListToDict(list: list)
    let firestoreList = Firestore.firestore().collection("lists").document()
    firestoreList.setData(listDict)
    return firestoreList.documentID
}

func updateList(list: ShowList) {
    let listDict = convertListToDict(list: list)
    Firestore.firestore().collection("lists").document(list.id).updateData(listDict)
}

func addList(list: ShowList, userId: String) {
    let listId = addListToLists(list: list)
    Firestore.firestore().collection("users").document(userId).updateData([
        "showLists": FieldValue.arrayUnion([listId])
    ])
}

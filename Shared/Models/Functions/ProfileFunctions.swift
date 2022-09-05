//
//  ProfileFunctions.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Firebase

// Expected input (id, username)
func followUser(userToFollow: (String, String), currentUser: (String, String)) {
    //let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users").document(userToFollow.0).updateData([
        "followers.\(currentUser.0)": currentUser.1
    ])
    incrementFollowerCount(userId: userToFollow.0)
    Firestore.firestore().collection("users").document(currentUser.0).updateData([
        "following.\(userToFollow.0)": userToFollow.1
    ])
    incrementFollowingCount(userId: currentUser.0)
}

func incrementFollowerCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "followerCount": FieldValue.increment(Int64(1))
    ])
}

func incrementFollowingCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "followingCount": FieldValue.increment(Int64(1))
    ])
}

// Expected input (id, username)
func unfollowUser(userToUnfollow: (String, String), currentUser: (String, String)) {
    //let uid = Auth.auth().currentUser!.uid
    Firestore.firestore().collection("users").document(userToUnfollow.0).updateData([
        "followers.\(currentUser.0)": FieldValue.delete()
    ])
    decrementFollowerCount(userId: userToUnfollow.0)
    Firestore.firestore().collection("users").document(currentUser.0).updateData([
        "following.\(userToUnfollow.0)": FieldValue.delete()
    ])
    decrementFollowingCount(userId: currentUser.0)
}

func decrementFollowerCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "followerCount": FieldValue.increment(Int64(-1))
    ])
}

func decrementFollowingCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "followingCount": FieldValue.increment(Int64(-1))
    ])
}

func pinShow(showId: String, showName: String) {
    Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
        "pinnedShows.\(showId)": showName
    ])
    incrementPinnedShowCount(userId: Auth.auth().currentUser!.uid)
}

func incrementPinnedShowCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "pinnedShowCount": FieldValue.increment(Int64(1))
    ])
}

func unpinShow(showId: String, showName: String) {
    Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
        "pinnedShows.\(showId)": FieldValue.delete()
    ])
    decrementPinnedShowCount(userId: Auth.auth().currentUser!.uid)
}

func decrementPinnedShowCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "pinnedShowCount": FieldValue.increment(Int64(-1))
    ])
}

func incrementShowCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "showCount": FieldValue.increment(Int64(1))
    ])
}

func decrementShowCount(userId: String) {
    Firestore.firestore().collection("users").document(userId).updateData([
        "showCount": FieldValue.increment(Int64(-1))
    ])
}



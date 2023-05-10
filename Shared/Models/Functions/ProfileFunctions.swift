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

// Ignores ID
func convertProfileToDictionary(profile: Profile) -> [String:Any] {
    var out = [String:Any]()
    out["username"] = profile.username
    out["pinnedShowCount"] = profile.pinnedShowCount
    out["showCount"] = profile.showCount
    out["followingCount"] = profile.followingCount
    out["followerCount"] = profile.followerCount
    return out
}

func convertProfileDictToProfile(profileId: String, data: [String:Any]) -> Profile {
    let username = data["username"] as! String
    var profilePhotoURL = data["profilePhotoURL"] as? String
    let bio = data["bio"] as? String
    let showCount = data["showCount"] as! Int
    
    let followingCount = data["followingCount"] as! Int
    let followerCount = data["followerCount"] as! Int
    let followers = data["followers"] as? [String:String]
    let following = data["following"] as? [String:String]
    
    let showLists = data["showLists"] as? [String]
    let likedShowLists = data["likedShowLists"] as? [String]
    
    let pinnedShows =  data["pinnedShows"] as? [String:String]
    let pinnedShowCount = data["pinnedShowCount"] as? Int ?? 0
    let add = Profile(id: profileId, username: username, profilePhotoURL: profilePhotoURL, bio: bio, pinnedShows: pinnedShows, pinnedShowCount: pinnedShowCount, showCount: showCount, followingCount: followingCount, followerCount: followerCount, followers: followers, following: following, showLists: showLists, likedShowLists: likedShowLists)
    return add
}

func createNewUser(username: String) {
    let newUID = Auth.auth().currentUser!.uid
    print("Heres the uid: \(newUID)")
    let profile = Profile(id: newUID, username: username, pinnedShowCount: 0, showCount: 0, followingCount: 0, followerCount: 0)
    let profileData = convertProfileToDictionary(profile: profile)
    let docRef = Firestore.firestore().collection("users").document(newUID)
    print(docRef)
    docRef.setData(profileData)
}


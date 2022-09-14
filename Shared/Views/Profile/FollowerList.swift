//
//  FollowerList.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import SwiftUI
import Firebase

struct FollowerList: View {
    
    @ObservedObject var modelData = ModelData()
    
    var followerList: [String: String] // ID: Username
    var type: String
    
    @State var unfollowConfirmation = false;
    
    var body: some View {
        List {
            ForEach(followerList.sorted(by: >), id:\.key) { id, username in
                NavigationLink(destination: ProfileDetail(id: id)) {
                    HStack {
                        Text(username)
                        Spacer()
                        // Follow buttons
                        let curUserOpt = modelData.currentUser
                        if (curUserOpt != nil) {
                            let curUser = curUserOpt!
                            HStack {
                                if (id == curUser.id) {
                                    Button(action: {
                                        // Nothing
                                    }) {
                                        Text("You")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.blue)
                                } else if (curUser.following != nil && curUser.following![id] != nil) {
                                    Button(action: {
                                        unfollowConfirmation = true
                                    }) {
                                        Text("Following")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.green)
                                    .confirmationDialog("Are you sure you want to unfollow \(username)?", isPresented: $unfollowConfirmation) {
                                        Button("Unfollow \(username)", role: .destructive) {
                                            unfollowUser(userToUnfollow: (id, username), currentUser: (curUser.id, curUser.username))
                                        }
                                    } message: {
                                        Text("Are you sure you want to unfollow \(username)?")
                                    }
                                } else {
                                    Button(action: {
                                        // Follow User
                                        followUser(userToFollow: (id, username), currentUser: (curUser.id, curUser.username))
                                    }) {
                                        Text("+ Follow \(username)")
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .navigationTitle(type)
        .listStyle(.automatic)
    }
}


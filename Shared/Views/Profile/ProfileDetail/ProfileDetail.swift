//
//  ProfileDetail.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import SwiftUI
import Firebase

struct ProfileDetail: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @StateObject var prof = ProfileViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    let id: String
    
    let curUserId = Auth.auth().currentUser!.uid
    
    @State var unfollowConfirmation: Bool = false
    
    var currentProfile: Bool { prof.profile != nil && prof.profile!.id == curUserId }
    
    var body: some View {
        let optProfile: Profile? = prof.profile
        ScrollView {
            VStack {
                if (optProfile == nil) {
                    Text("Loading Profile")
                } else {
                    let profile = optProfile!
                    VStack (alignment: .leading) {
                        userDetails
                        
                        Divider()
                        
                        PinnedShowsSection(profile: profile, currentProfile: currentProfile)
                        
                        Divider()
                        
                        ownedLists
                    }
                    .navigationTitle(profile.username)
                }
            }
            .task {
                prof.loadProfile(modelData: modelData, id: id)
            }
        }
    }
    
    var userDetails: some View {
        
        VStack {
            
            let optProfile: Profile? = prof.profile
            let profilePic: Image? = prof.profilePic
            
            let profile = optProfile!
            
            HStack {
                VStack {
                    if (profilePic != nil) {
                        VStack {
                            profilePic!
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .scaledToFit()
                                .shadow(radius: 5)
                        }
                        .frame(width: 125, height: 125, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    } else {
                        //Text("Loading Profile Picture")
                    }
                }
                .padding(2)
                VStack (alignment: .leading) {
                    HStack {
                        Text("@\(profile.username)")
                            .font(.title)
                            .italic()
                            .bold()
                    }
                    HStack {
                        if (currentProfile) {
                            Button(action: {
                                // Nothing
                            }) {
                                Text("You")
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                        } else if (profile.followers != nil && profile.followers![curUserId] != nil) {
                            Button(action: {
                                unfollowConfirmation = true
                            }) {
                                Text("Following")
                            }
                            .buttonStyle(.bordered)
                            .tint(.green)
                            .confirmationDialog("Are you sure you want to unfollow \(profile.username)?", isPresented: $unfollowConfirmation) {
                                Button("Unfollow \(profile.username)", role: .destructive) {
                                    unfollowUser(userToUnfollow: (profile.id, profile.username), currentUser: (curUserId, modelData.currentUser!.username))
                                }
                            } message: {
                                Text("Are you sure you want to unfollow \(profile.username)?")
                            }
                        } else {
                            Button(action: {
                                // Follow User
                                followUser(userToFollow: (profile.id, profile.username), currentUser: (curUserId, modelData.currentUser!.username))
                            }) {
                                Text("+ Follow \(profile.username)")
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        if (currentProfile) {
                            //Spacer()
                            Button(action: {
                                modelData.entered = false
                                try! Auth.auth().signOut()
                            }) {
                                Text("Logout")
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                    if (profile.bio != nil) {
                        Text("\(profile.bio!)")
                    }
                    Text("\(profile.showCount) shows logged")
                        .bold()
                    
                    followerSection
                }
                    
            }
        }
        .padding()
    }
    
    var followerSection: some View {
        HStack {
            let optProfile: Profile? = prof.profile
            //var profilePic: Image? = prof.profilePic
            
            let profile = optProfile!
            
            if (profile.followers != nil) {
                NavigationLink(destination: FollowerList(followerList: profile.followers!, type: "\(profile.username)'s Followers")) {
                    VStack {
                        Text("\(profile.followerCount)")
                            .font(.title)
                        Text("Followers")
                            .bold()
                    }
                    .padding(5)
                    .foregroundColor(Color.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2)
                    )
                    .padding(2)
                    .cornerRadius(10)
                }
            } else {
                Text("No followers")
                    .bold()
            }
            
            if (profile.following != nil) {
                NavigationLink(destination: FollowerList(followerList: profile.following!, type: "\(profile.username)'s Following")) {
                    VStack {
                        Text("\(profile.followingCount)")
                            .font(.title)
                        Text("Following")
                            .bold()
                    }
                    .padding(5)
                    .foregroundColor(Color.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2)
                    )
                    .padding(2)
                    .cornerRadius(10)
                }
            } else {
                Text("Not following anyone")
                    .bold()
            }
        }
    }
    
    
    @State var newListPresented = false
    @State var newList = ShowList(id: "", name: "New List", description: "", shows: [], ordered: false, priv: false, profile: Profile(id: Auth.auth().currentUser!.uid, username: "", pinnedShowCount: 0, showCount: 0, followingCount: 0, followerCount: 0), likeCount: 0)
    
    var ownedLists: some View {
        VStack(alignment: .leading) {
            let optProfile: Profile? = prof.profile
            if (optProfile != nil && (optProfile!.showLists != nil || currentProfile)) {
                let profile = optProfile!
                if (!currentProfile) {
                    Text("\(profile.username)'s Lists")
                        .font(.headline)
                } else {
                    Text("Your Lists")
                        .font(.headline)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        if (currentProfile) {
                            VStack {
                                Button(action: {
                                    newListPresented = true
                                }) {
                                    VStack {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                        Text("Create a new list")
                                            .font(.headline)
                                    }
                                    .frame(width: 150, height: 150)
                                }
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(alignment: .center)
                                .background(.green)
                                .cornerRadius(10)
                            }
                            .padding(5)
                        }
                        if (profile.showLists != nil) {
                            ForEach(profile.showLists!, id:\.self) { showListId in
                                NavigationLink(destination: ShowListDetail(listId: showListId)) {
                                    ShowListTile(showListId: showListId)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .sheet(isPresented: $newListPresented) {
            NavigationView {
                //ShowDetailEdit(isPresented: self.$isPresented, show: newShow, showIndex: shows.count-1)
                ShowListDetailEdit(showList: $newList, isPresented: self.$newListPresented)
                    .navigationTitle(newList.name)
                    .navigationBarItems(leading: Button("Cancel") {
                        newListPresented = false
                    }, trailing: Button("Done") {
                        addList(list: newList, userId: Auth.auth().currentUser!.uid)
                        newListPresented = false
                    })
            }
        }
        
    }
    
    
}


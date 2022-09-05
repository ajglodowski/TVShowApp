//
//  ProfileDetail.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import SwiftUI
import Firebase

struct ProfileDetail: View {
    
    @ObservedObject var modelData = ModelData()
    
    @StateObject var prof = ProfileViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    let id: String
    
    let curUserId = Auth.auth().currentUser!.uid
    
    @State var unfollowConfirmation: Bool = false
    
    @State var editingPinnedShows: Bool = false
    
    @State var pinnedShowText: String = ""
    var pinnedShowSearchList: [Show] {
        modelData.shows.filter { $0.name.lowercased().contains(pinnedShowText.lowercased())}
    }
    
    var currentProfile: Bool {
        prof.profile != nil && prof.profile!.id == curUserId
    }
    
    
    
    var body: some View {
        
        var optProfile: Profile? = prof.profile
        var profilePic: Image? = prof.profilePic
        
        ScrollView {
            
            VStack {
                
                if (optProfile != nil) {
                    let profile = optProfile!
                    VStack (alignment: .leading) {
                        
                        userDetails
                        
                        Section(header: Text("Pinned Shows:")) {
                            pinnedShowsRow
                        }
                        
                        Section(header: Text("More Data:")) {
                            
                            NavigationLink(destination: WatchList()) {
                                Text("All \(profile.username)'s logged shows")
                            }
                            
                        }
                        
                    }
                    .navigationTitle(profile.username)
                    .padding()
                } else {
                    Text("Loading Profile")
                }
                
            }
            /*
             .refreshable {
             if (!current) { await rm.fetchAll(year: year!, round: round!, current: false) }
             else { await rm.fetchAll(year: "", round: "", current: true) }
             }
             */
            .task {
                prof.loadProfile(id: id)
            }
        }
    }
    
    var pinnedShowsRow: some View {
        
        VStack(alignment: .leading) {
            
            var optProfile: Profile? = prof.profile
            var profilePic: Image? = prof.profilePic
            
            let profile = optProfile!
            if (profile.pinnedShows != nil && !profile.pinnedShows!.isEmpty) {
                HStack {
                    Text("\(profile.username)'s Pinned Shows:")
                        .font(.headline)
                    Spacer()
                    if (currentProfile) {
                        Button(action: {
                            editingPinnedShows.toggle()
                        }) {
                            if (!editingPinnedShows) {
                                Text("Edit Pinned Shows")
                            } else {
                                Text("Stop Editing Pinned Shows")
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(profile.pinnedShows!.sorted(by: >), id:\.key) { showId, showName in
                            VStack {
                                let showInd = modelData.shows.firstIndex(where: { $0.id == showId })
                                if (showInd != nil) {
                                    NavigationLink(destination: ShowDetail(show: modelData.shows[showInd!])) {
                                        ShowTile(showName: showName)
                                    }
                                    if (editingPinnedShows) {
                                        Button(action: {
                                            unpinShow(showId: showId, showName: showName)
                                        }) {
                                            HStack {
                                                Text("Remove Pinned Show")
                                                Image(systemName: "xmark")
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                } else {
                                    // Somehow load show
                                    ShowTile(showName: showName)
                                }
                            }
                        }
                    }
                    .foregroundColor(Color.primary)
                }
            } else {
                Text("This user hasn't pinned any shows 😔")
                    .font(.headline)
            }
            VStack(alignment: .leading) {
                if (profile.id == curUserId && editingPinnedShows) {
                    Text("Add more pinned shows")
                    HStack { // Search Bar
                        Image(systemName: "magnifyingglass")
                        TextField("Search for a show here", text: $pinnedShowText)
                            .disableAutocorrection(true)
                        if (!pinnedShowText.isEmpty) {
                            Button(action: { pinnedShowText = "" }, label: {
                                Image(systemName: "xmark")
                            })
                        }
                    }
                    ForEach(pinnedShowSearchList) { show in
                        Button(action: {
                            pinShow(showId: show.id, showName: show.name)
                        }, label: {
                            Text(show.name)
                        })
                    }
                }
            }
        }
    }
    
    var userDetails: some View {
        
        VStack {
            
            var optProfile: Profile? = prof.profile
            var profilePic: Image? = prof.profilePic
            
            let profile = optProfile!
            
            HStack {
                VStack {
                    if (profilePic != nil) {
                        VStack {
                            profilePic!
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .scaledToFit()
                        }
                        .frame(width: 175, height: 175, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    } else {
                        Text("Loading Profile Picture")
                    }
                }
                .padding()
                VStack (alignment: .leading) {
                    HStack {
                        Text("@\(profile.username)")
                            .font(.title)
                            .italic()
                            .bold()
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
                            Spacer()
                            Button(action: {
                                modelData.loggedIn = false
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
    }
    
    var followerSection: some View {
        HStack {
            var optProfile: Profile? = prof.profile
           var profilePic: Image? = prof.profilePic
            
            let profile = optProfile!
            
            if (profile.followers != nil) {
                NavigationLink(destination: FollowerList(followerList: profile.followers!, type: "\(profile.username)'s Followers")) {
                    VStack {
                        Text("\(profile.followerCount)")
                            .font(.title)
                        Text("Followers")
                            .bold()
                    }
                    .padding()
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
                    .padding()
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
    
    
}
/*
 struct ProfileDetail_Previews: PreviewProvider {
 static var previews: some View {
 ProfileDetail()
 }
 }
 */

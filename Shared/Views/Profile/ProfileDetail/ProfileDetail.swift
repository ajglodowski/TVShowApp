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
    @StateObject var imageVm = ProfilePictureViewModel()
    
    var profilePic: UIImage? { imageVm.profilePicture }
    
    let id: String
    var curUserId: String? { modelData.currentUser?.id }
    
    @State var unfollowConfirmation: Bool = false
    
    var currentProfile: Bool { prof.profile != nil && prof.profile!.id == curUserId }
    
    @State var newListPresented = false
    
    var body: some View {
        //let optProfile: Profile? = prof.profile // No longer needed directly here
        ScrollView {
            VStack {
                // Use ViewModel's loading state
                if prof.isLoadingProfile || prof.profile == nil {
                    Text("Loading Profile...")
                    // Consider adding a ProgressView here
                    // ProgressView()
                } else {
                    let profile = prof.profile! // Safe to unwrap now
                    VStack (alignment: .leading) {
                        userDetails
                        
                        Divider()
                        
                        //PinnedShowsSection(profile: profile, currentProfile: currentProfile)
                        PinnedShowsSection()
                        
                        Divider()
                        
                        OwnedLists(profile: profile)
                    }
                    .navigationTitle(profile.username)
                    // Add error message display if needed
                    if let errorMsg = prof.errorMessage {
                        Text("Error: \(errorMsg)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
            .task(id: id) { // Use task with id to reload if id changes
                await prof.loadProfileData(id: id) // Call the new loading function
                await imageVm.loadImage(userId: id) // Add image loading call
            }
        }
    }
    
    var userDetails: some View {
        VStack {
            // Use prof.profile safely, as body checks for loading state
            if let profile = prof.profile {
                HStack {
                    VStack {
                        if (profilePic != nil) {
                            VStack {
                                Image(uiImage: profilePic)
                                    .resizable()
                                    .skeleton(with: profilePic == nil, shape: .rectangle)
                                    .clipShape(Circle())
                                    .scaledToFit()
                                    .shadow(radius: 5)
                            }
                            .frame(width: 125, height: 125, alignment: .center)
                        } else {
                            // Placeholder for profile picture if needed
                            Circle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(width: 125, height: 125)
                                .overlay(Image(systemName: "person.fill").resizable().scaledToFit().padding(30).foregroundColor(.white))
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
                        /*
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
                                        //unfollowUser(userToUnfollow: (profile.id, profile.username), currentUser: (curUserId, modelData.currentUser!.username))
                                    }
                                } message: {
                                    Text("Are you sure you want to unfollow \(profile.username)?")
                                }
                            } else {
                                Button(action: {
                                    // Follow User
                                    //followUser(userToFollow: (profile.id, profile.username), currentUser: (curUserId, modelData.currentUser!.username))
                                }) {
                                    Text("+ Follow \(profile.username)")
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            if (currentProfile) {
                                //Spacer()
                                Button(action: {
                                    Task {
                                        await supabase.auth.signOut()
                                    }
                                }) {
                                    Text("Logout")
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                         */
                        if (profile.bio != nil) {
                            Text("\(profile.bio!)")
                        }
                        
                        // Display show count from ViewModel
                        if prof.isLoadingShowCount {
                            Text("Loading shows...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .redacted(reason: .placeholder)
                        } else {
                            Text("\(prof.showsLoggedCount ?? 0) shows logged")
                                .bold()
                        }
                        
                        followerSection
                    }
                }
            } else {
                // Placeholder while profile is loading (body already handles main loading text)
                EmptyView()
            }
        }
        .padding()
    }
    
    var followerSection: some View {
        // Use a VStack to stack the links vertically
        VStack(alignment: .leading, spacing: 8) { // Add spacing between lines
            let optProfile: Profile? = prof.profile
            
            if let profile = optProfile {
                // Profile loaded: Show follower/following links
                NavigationLink(destination: FollowerList(userId: profile.id, listType: .followers, profileUsername: profile.username)) {
                    HStack {
                        Text("**\(profile.followerCount ?? 0)** Followers")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary) // Make chevron less prominent
                    }
                    .foregroundColor(Color.primary) // Keep text color standard
                }
                
                NavigationLink(destination: FollowerList(userId: profile.id, listType: .following, profileUsername: profile.username)) {
                    HStack {
                        Text("**\(profile.followingCount ?? 0)** Following")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(Color.primary) // Keep text color standard
                }
            } else {
                // Profile not loaded yet: Show placeholder
                HStack {
                    Text("Loading counts...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                         .foregroundColor(.secondary)
                }
                .redacted(reason: .placeholder)
                // You might want a second placeholder line for symmetry
                HStack {
                    Text("Loading counts...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                     Spacer()
                    Image(systemName: "chevron.right")
                         .foregroundColor(.secondary)
                }
                .redacted(reason: .placeholder)
            }
        }
        .padding(.vertical, 4) // Add a little vertical padding to the VStack
    }
}

#Preview {
    let id = "c52a052a-4944-4257-ad77-34f2f002104c"
    NavigationView {
        ProfileDetail(id: id)
            .environmentObject(ModelData())
    }
}


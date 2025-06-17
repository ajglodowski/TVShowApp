//
//  FollowerList.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import SwiftUI
import Firebase

struct FollowerList: View {
    
    @EnvironmentObject var modelData : ModelData
    
    let userId: String
    let listType: FollowListType
    let profileUsername: String // Pass the username for the title
    
    @StateObject var viewModel = FollowerListViewModel()
    
    //@State var unfollowConfirmation = false; // Move follow logic if needed
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let users = viewModel.users {
                if users.isEmpty {
                    Text("No users found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(users) { user in
                        NavigationLink(destination: ProfileDetail(id: user.id)) {
                            HStack {
                                // TODO: Add Profile Picture Here (using user.profilePhotoURL)
                                Text(user.username)
                                Spacer()
                                // TODO: Re-implement Follow/Unfollow buttons if necessary
                                // This might require fetching the current user's following status
                                // or passing it down.
                            }
                        }
                    }
                }
            } else if let errorMsg = viewModel.errorMessage {
                Text("Error: \(errorMsg)")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(navigationTitleText)
        .task {
            await viewModel.loadList(userId: userId, type: listType)
        }
    }
    
    var navigationTitleText: String {
        switch listType {
        case .followers:
            return "\(profileUsername)'s Followers"
        case .following:
            return "\(profileUsername) Following"
        }
    }
}

// Preview might need adjustment if it relied on the old structure
/*
#Preview {
    // Example preview setup (replace with actual data or mocks)
    FollowerList(userId: "some_user_id", listType: .followers, profileUsername: "ExampleUser")
        .environmentObject(ModelData())
}
*/


//
//  ProfileTile.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import SwiftUI

struct ProfileTile: View {
    
    var profileId: String
    @EnvironmentObject var modelData: ModelData
    @StateObject var prof = ProfileViewModel()
    @StateObject var profPicVm = ProfilePictureViewModel()
    
    var profile: Profile? { prof.profile }
    var profilePic: UIImage? { profPicVm.profilePicture }
    
    var body: some View {
        NavigationLink(destination: ProfileDetail(id: profileId)) {
            HStack {
                VStack {
                    if (profilePic != nil) {
                        Image(uiImage: profilePic!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 75, height: 75)
                            .overlay(Image(systemName: "person.fill").resizable().scaledToFit().padding(20).foregroundColor(.white))
                    }
                }
                
                profileInfoView
                
                Spacer()
            }
        }
        .task {
            await prof.loadProfileData(id: profileId)
            await profPicVm.loadImage(userId: profileId)
        }
    }
    
    @ViewBuilder
    private var profileInfoView: some View {
        VStack(alignment: .leading) {
            if let username = prof.profile?.username {
                Text(username)
                    .font(.headline)
                    .bold()
            } else {
                Text("Loading...")
                    .font(.headline)
                    .redacted(reason: .placeholder)
            }
            
            if prof.isLoadingShowCount {
                Text("-")
                    .font(.subheadline)
                    .redacted(reason: .placeholder)
            } else {
                Text("\(prof.showsLoggedCount ?? 0) shows")
                    .font(.subheadline)
                    .italic()
            }
            
            if prof.isLoadingProfile {
                Text("-")
                    .font(.subheadline)
                    .redacted(reason: .placeholder)
            } else {
                Text("\(prof.profile?.followerCount ?? 0) followers")
                    .font(.subheadline)
            }
        }
    }
}

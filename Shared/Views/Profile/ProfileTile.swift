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
        HStack {
            if (profile != nil && profilePic != nil) {
                let loadedProfile = profile!
                NavigationLink(destination: ProfileDetail(id: profileId)) {
                    Image(uiImage: profilePic!)
                        .resizable()
                        .skeleton(with: profilePic == nil, shape: .rectangle)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(loadedProfile.username)
                            .font(.title)
                            .bold()
                        Text("\(loadedProfile.showCount) shows logged")
                            .italic()
                        Text("\(loadedProfile.followerCount) followers")
                    }
                }
            }
        }
        .task {
            await prof.loadProfile(id: profileId)
            await profPicVm.loadImage(userId: profileId)
        }
    }
}

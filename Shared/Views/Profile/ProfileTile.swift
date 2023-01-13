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
    
    var profile: Profile? {
        prof.profile
    }
    var profilePic: Image? {
        prof.profilePic
    }
    
    var body: some View {
        HStack {
            if (profile != nil && profilePic != nil) {
                var loadedProfile = profile!
                NavigationLink(destination: ProfileDetail(id: profileId)) {
                    profilePic!
                        .resizable()
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
            prof.loadProfile(modelData: modelData, id: profileId)
        }
    }
}

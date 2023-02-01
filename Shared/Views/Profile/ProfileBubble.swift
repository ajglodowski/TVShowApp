//
//  ProfileBubble.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/12/23.
//

import SwiftUI

struct ProfileBubble: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var prof = ProfileViewModel()
    var profile: Profile? { modelData.profiles[profileId] }
    var profilePic: Image? { modelData.profilePics[profileId] }
    
    var profileId: String
    
    var body: some View {
        
        HStack {
            if (profile == nil || profilePic == nil) { Text("Loading Profile") }
            else {
                NavigationLink(destination: ProfileDetail(id: profile!.id)) {
                    HStack {
                        profilePic!
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                        Text(profile!.username)
                            .font(.callout)
                    }
                    .padding(.vertical, -7)
                    .padding(.trailing, -3)
                    .padding(.leading, -11)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .foregroundColor(.white)
                //.padding(-1)
            }
        }
        .task {
            prof.loadProfile(modelData: modelData, id: profileId)
        }
    }
}

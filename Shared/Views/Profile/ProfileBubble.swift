//
//  ProfileBubble.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/12/23.
//

import SwiftUI

struct ProfileBubble: View {
    
    @StateObject var prof = ProfileViewModel()
    @StateObject var imageVm = ProfilePictureViewModel()
    
    var profile: Profile? { prof.profile }
    var profilePic: UIImage? { imageVm.profilePicture }
    
    var profileId: String
    
    var body: some View {
        
        HStack {
            NavigationLink(destination: ProfileDetail(id: profileId)) {
                HStack {
                    Image(uiImage: profilePic)
                        .resizable()
                        .skeleton(with: profilePic == nil, shape: .rectangle)
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    Text(profile?.username)
                        .skeleton(with: profile == nil, shape: .rectangle)
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
        .task {
            await prof.loadProfile(id: profileId)
            await imageVm.loadImage(userId: profileId)
        }
    }
}

#Preview {
    return ProfileBubble(profileId: MockSupabaseProfile.id)
}

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
    
    var passedProfile : Profile?
    var profile: Profile? { passedProfile ?? prof.profile }
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
            Spacer()
        }
        .frame(height: 15)
        .frame(maxWidth: 128)
        .padding(.vertical, 5)
        .task {
            await prof.loadProfileData(id: profileId)
            await imageVm.loadImage(userId: profileId)
        }
    }
}

struct ProfileBubbleLoading: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                HStack {
                    Rectangle()
                        .skeleton(with: true, shape: .rectangle)
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    
                    Text("Loading")
                        .skeleton(with: true, shape: .rectangle)
                        .font(.callout)
                }
                .padding(.vertical, -7)
                .padding(.trailing, -3)
                .padding(.leading, -11)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .foregroundColor(.white)
            .disabled(true)
            
            Spacer()
        }
        .frame(height: 15)
        .frame(maxWidth: 128)
        .padding(.vertical, 5)
    }
}

#Preview {
    let profile = Profile(from: MockSupabaseProfile);
    var profile2 = Profile(from: MockSupabaseProfile);
    profile2.username = "Some super long username that should truncate";
    return (
        VStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Some text above")
                    ProfileBubble(passedProfile: profile, profileId: MockSupabaseProfile.id)
                }
                .padding(10)
                .background(content: { Color.red })
            }
            .padding(10)
            .background(content: { Color.blue })
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Some text above")
                    ProfileBubble(passedProfile: profile2, profileId: MockSupabaseProfile.id)
                }
                .padding(10)
                .background(content: { Color.red })
            }
            .padding(10)
            .background(content: { Color.blue })
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Some text above")
                    ProfileBubble(profileId: MockSupabaseProfile.id)
                }
                .padding(10)
                .background(content: { Color.red })
            }
            .padding(10)
            .background(content: { Color.blue })
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Some text above")
                    ProfileBubbleLoading()
                }
                .padding(10)
                .background(content: { Color.red })
            }
            .padding(10)
            .background(content: { Color.blue })
        }
    )
}

#Preview("Loading ProfileBubble") {
    VStack {
        VStack(alignment: .leading) {
            Text("Some text above")
            ProfileBubbleLoading()
        }
        .padding(10)
        .background(content: { Color.red })
    }
    .padding(10)
    .background(content: { Color.blue })
}

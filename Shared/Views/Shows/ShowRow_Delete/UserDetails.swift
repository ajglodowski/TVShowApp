//
//  UserDetails.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI
import SkeletonUI

struct UserDetails: View {
    let userInfo: UserShowDataWithUserInfo
    
    @StateObject private var prof = ProfileViewModel()
    
    var body: some View {
        NavigationLink(destination: ProfileDetail(id: userInfo.user.id)) {
            HStack(spacing: 12) {
                // Smaller avatar for the dropdown
                AvatarBubble(
                    userId: userInfo.user.id,
                    rating: userInfo.showDetails.rating,
                    size: 32
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(userInfo.user.username)
                        .font(.headline)
                        .skeleton(with: prof.profile == nil, shape: .rectangle)
                    
                    Text("Current Season: \(userInfo.showDetails.currentSeason)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Status: \(userInfo.showDetails.status.name)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .task {
            await prof.loadProfileData(id: userInfo.user.id)
        }
    }
}

#Preview {
    let mockUserInfo = UserShowDataWithUserInfo(
        user: UserBasicInfo(id: MockSupabaseProfile.id, username: "testuser", profilePhotoURL: nil),
        showDetails: ShowUserSpecificDetails(
            userId: MockSupabaseProfile.id,
            showId: 1,
            status: MockStatus,
            updated: Date(),
            currentSeason: 3,
            rating: Rating.Loved
        )
    )
    
    return UserDetails(userInfo: mockUserInfo)
} 
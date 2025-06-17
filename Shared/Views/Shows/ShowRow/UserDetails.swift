//
//  UserDetails.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI

struct UserDetails: View {
    let userInfo: UserShowDataWithUserInfo
    
    var body: some View {
        HStack(spacing: 8) {
            // Smaller avatar for the dropdown
            AvatarBubble(
                userId: userInfo.user.id,
                rating: userInfo.showDetails.rating,
                size: 24
            )
            
            // Single line with all info to work with menu limitations
            Text("\(userInfo.user.username) • S\(userInfo.showDetails.currentSeason) • \(userInfo.showDetails.status.name)")
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)
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

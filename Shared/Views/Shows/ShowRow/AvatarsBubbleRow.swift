//
//  AvatarsBubbleRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI

struct AvatarsBubbleRow: View {
    let currentUserInfo: UserShowDataWithUserInfo?
    let otherUsersInfo: [UserShowDataWithUserInfo]
    let avatarSize: CGFloat = 40
    
    var allUsers: [UserShowDataWithUserInfo] {
        var users: [UserShowDataWithUserInfo] = []
        if let currentUser = currentUserInfo {
            users.append(currentUser)
        }
        users.append(contentsOf: otherUsersInfo)
        return users
    }
    
    var body: some View {
        HStack(spacing: -avatarSize * 0.3) { // Overlap by 30% of avatar size
            ForEach(Array(allUsers.enumerated()), id: \.element.id) { index, userInfo in
                AvatarBubble(
                    userId: userInfo.user.id,
                    rating: userInfo.showDetails.rating,
                    size: avatarSize
                )
                .zIndex(Double(allUsers.count - index))
            }
        }
    }
}

struct AvatarsBubbleRowLoading: View {

    let avatarSize: CGFloat = 40
    let userCount = 3
    
    var body: some View {
        HStack(spacing: -avatarSize * 0.3) { // Overlap by 30% of avatar size
            ForEach(0..<userCount, id: \.self) { index in
                AvatarBubbleLoading(size: avatarSize)
                .zIndex(Double(userCount - index))
            }
        }
    }
}

#Preview {
    let mockUser1 = UserShowDataWithUserInfo(
        user: UserBasicInfo(id: "1", username: "user1", profilePhotoURL: nil),
        showDetails: ShowUserSpecificDetails(userId: "1", showId: 1, status: MockStatus, updated: Date(), currentSeason: 1, rating: Rating.Loved)
    )
    
    let mockUser2 = UserShowDataWithUserInfo(
        user: UserBasicInfo(id: "2", username: "user2", profilePhotoURL: nil),
        showDetails: ShowUserSpecificDetails(userId: "2", showId: 1, status: MockStatus, updated: Date(), currentSeason: 2, rating: Rating.Liked)
    )
    
    return (
        VStack {
            VStack {
                AvatarsBubbleRow(
                    currentUserInfo: mockUser1,
                    otherUsersInfo: [mockUser2, mockUser2, mockUser2, mockUser2])
            }
            .padding(20)
            .background(.blue)
            
            VStack {
                AvatarsBubbleRowLoading()
            }
            .padding(20)
            .background(.blue)
        }
    )
}

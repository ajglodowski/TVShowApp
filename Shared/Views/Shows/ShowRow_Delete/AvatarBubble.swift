//
//  AvatarBubble.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI
import SkeletonUI

struct AvatarBubble: View {
    let userId: String
    let rating: Rating?
    let size: CGFloat
    
    @StateObject private var imageVm = ProfilePictureViewModel()
    
    var body: some View {
        ZStack {
            // Reuse existing profile image logic from ProfileBubble
            if let profilePic = imageVm.profilePicture {
                Image(uiImage: profilePic)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: size, height: size)
                    .skeleton(with: true, shape: .rectangle)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(size * 0.3)
                            .foregroundColor(.white)
                    )
            }
            
            // Add rating indicator overlay (similar to NextJS version)
            if let rating = rating {
                Image(systemName: "\(rating.ratingSymbol).fill")
                    .foregroundColor(rating.color)
                    .font(.system(size: size * 0.25))
                    .background(
                        Circle()
                            .fill(.background)
                            .frame(width: size * 0.35, height: size * 0.35)
                    )
                    .offset(x: size * 0.25, y: size * 0.25)
            }
        }
        .task {
            await imageVm.loadImage(userId: userId)
        }
    }
}

#Preview {
    HStack {
        AvatarBubble(userId: MockSupabaseProfile.id, rating: nil, size: 40)
        AvatarBubble(userId: MockSupabaseProfile.id, rating: Rating.Loved, size: 40)
        AvatarBubble(userId: MockSupabaseProfile.id, rating: Rating.Liked, size: 32)
    }
} 
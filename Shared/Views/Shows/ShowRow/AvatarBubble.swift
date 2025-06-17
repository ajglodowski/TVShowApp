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
            Image(uiImage: imageVm.profilePicture)
                .resizable()
                .scaledToFill()
                .skeleton(with: imageVm.profilePicture == nil, shape: .rectangle)
                .frame(width: size, height: size)
                .clipShape(Circle())
            
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

struct AvatarBubbleLoading: View {

    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Reuse existing profile image logic from ProfileBubble
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .skeleton(with: true, shape: .rectangle)
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}


#Preview {
    HStack {
        AvatarBubble(userId: MockSupabaseProfile.id, rating: nil, size: 40)
        AvatarBubble(userId: MockSupabaseProfile.id, rating: Rating.Loved, size: 40)
        AvatarBubble(userId: MockSupabaseProfile.id, rating: Rating.Liked, size: 32)
        AvatarBubbleLoading(size: 40)
    }
} 

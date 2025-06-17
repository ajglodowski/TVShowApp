//
//  AvatarBubbleLoading.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI
import SkeletonUI

struct AvatarBubbleLoading: View {
    let size: CGFloat = 40
    
    var body: some View {
        Circle()
            .fill(Color.secondary.opacity(0.3))
            .frame(width: size, height: size)
            .skeleton(with: true, shape: .rectangle)
    }
} 
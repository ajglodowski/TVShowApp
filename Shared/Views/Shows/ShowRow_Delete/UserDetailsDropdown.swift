//
//  UserDetailsDropdown.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import SwiftUI
import SkeletonUI

struct UserDetailsDropdown: View {
    let showId: Int
    
    @State private var multiUserData: ShowMultiUserData?
    @State private var isLoading = true
    
    var body: some View {
        HStack {
            Spacer()
            
            if isLoading {
                // Loading state using skeleton pattern
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .skeleton(with: true, shape: .rectangle)
            } else if let data = multiUserData, data.hasAnyUsers {
                Menu {
                    // Current user section
                    if let currentUser = data.currentUserData {
                        Section("You") {
                            UserDetails(userInfo: currentUser)
                        }
                    }
                    
                    // Friends section
                    if !data.otherUsersData.isEmpty {
                        Section("Friends") {
                            ForEach(data.otherUsersData, id: \.id) { userInfo in
                                UserDetails(userInfo: userInfo)
                            }
                        }
                    }
                } label: {
                    AvatarsBubbleRow(
                        currentUserInfo: data.currentUserData,
                        otherUsersInfo: data.otherUsersData
                    )
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                }
                .menuStyle(.borderlessButton)
            }
        }
        .task(id: showId) {
            await loadMultiUserData()
        }
    }
    
    private func loadMultiUserData() async {
        isLoading = true
        
        let data = await getMultiUserShowData(showId: showId)
        
        await MainActor.run {
            multiUserData = data
            isLoading = false
        }
    }
}

#Preview {
    UserDetailsDropdown(showId: 1)
} 
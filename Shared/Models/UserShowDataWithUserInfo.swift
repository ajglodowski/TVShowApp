//
//  UserShowDataWithUserInfo.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import Foundation

struct UserShowDataWithUserInfo: Identifiable, Hashable {
    let id: String
    let user: UserBasicInfo
    let showDetails: ShowUserSpecificDetails
    
    init(user: UserBasicInfo, showDetails: ShowUserSpecificDetails) {
        self.id = "\(user.id)_\(showDetails.showId)"
        self.user = user
        self.showDetails = showDetails
    }
}

struct ShowMultiUserData {
    let showId: Int
    let currentUserData: UserShowDataWithUserInfo?
    let otherUsersData: [UserShowDataWithUserInfo]
    
    var hasAnyUsers: Bool {
        currentUserData != nil || !otherUsersData.isEmpty
    }
    
    var allUsers: [UserShowDataWithUserInfo] {
        var users: [UserShowDataWithUserInfo] = []
        if let currentUser = currentUserData {
            users.append(currentUser)
        }
        users.append(contentsOf: otherUsersData)
        return users
    }
} 
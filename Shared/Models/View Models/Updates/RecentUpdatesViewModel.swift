//
//  RecentUpdatesViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/11/24.
//

import Foundation

class RecentUpdatesViewModel: ObservableObject {
    
    private let currentUserId = supabase.auth.currentUser?.id.uuidString
    
    @Published
    var currentUserUpdates: [UserUpdate]? = nil
    
    @Published
    var friendUpdates: [UserUpdate]? = nil
    
    @MainActor
    func setCurrentUserUpdates(updates: [UserUpdate]?) {
        self.currentUserUpdates = updates
    }
    
    @MainActor
    func setFriendUpdates(updates: [UserUpdate]?) {
        self.friendUpdates = updates
    }
    
    func loadUpdates() async {
        if (currentUserId == nil) { return }
        let friendIds = await getFriendIds(userId: currentUserId!)
        async let currentUserTask = self.loadUserUpdates()
        async let friendUpdatesTask = self.loadFriendUpdates(friends: friendIds ?? [])
        await (currentUserTask, friendUpdatesTask)
    }
    
    private func loadUserUpdates() async {
        if (currentUserId == nil) { return }
        let fetched = await getMostRecentUpdates(userIds: [currentUserId!])
        await setCurrentUserUpdates(updates: fetched)
    }
    
    
    private func loadFriendUpdates(friends: [String]) async {
        let fetched = await getMostRecentUpdates(userIds: friends)
        await setFriendUpdates(updates: fetched)
    }
    
}

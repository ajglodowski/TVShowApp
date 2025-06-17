//
//  ShowUpdatesViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/12/23.
//

import Foundation

import Foundation
import Swift
import SwiftUI

class ShowUpdatesViewModel: ObservableObject {
    
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
    
    func loadUpdates(showId: Int) async {
        if (currentUserId == nil) { return }
        async let currentUserTask = self.loadUserUpdates(showId: showId)
        async let friendUpdatesTask = self.loadFriendUpdates(showId: showId, friends: [])
        await (currentUserTask, friendUpdatesTask)
    }
    
    private func loadUserUpdates(showId: Int) async {
        if (currentUserId == nil) { return }
        let fetched = await getShowUpdatesForUsers(showId: showId, userIds: [currentUserId!])
        await setCurrentUserUpdates(updates: fetched)
    }
    
    
    private func loadFriendUpdates(showId: Int, friends: [String]) async {
        let fetched = await getShowUpdatesForUsers(showId: showId, userIds: friends)
        await setFriendUpdates(updates: fetched)
    }
    
}

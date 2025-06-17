//
//  FollowerListViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 4/26/25.
//

import Foundation
import SwiftUI

enum FollowListType {
    case followers
    case following
}

@MainActor
class FollowerListViewModel: ObservableObject {
    
    @Published var users: [UserBasicInfo]? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func loadList(userId: String, type: FollowListType) async {
        guard !isLoading else { return } // Prevent concurrent loads
        isLoading = true
        errorMessage = nil
        users = nil // Clear previous results
        
        do {
            switch type {
            case .followers:
                users = await fetchFollowerList(userId: userId)
            case .following:
                users = await fetchFollowingList(userId: userId)
            }
        } catch {
            errorMessage = "Failed to load list: \(error.localizedDescription)"
            print("Error loading list: \(error)") // Keep for debugging
        }
        
        isLoading = false
    }
} 

//
//  ProfileViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    
    @Published var profile: Profile? = nil
    @Published var showsLoggedCount: Int? = nil
    @Published var isLoadingProfile: Bool = false
    @Published var isLoadingShowCount: Bool = false
    @Published var errorMessage: String? = nil
    
    let fetcherInstance = ProfileFetcher.shared
    
    @MainActor
    private func setProfile(profile: Profile?) {
        self.profile = profile
        self.isLoadingProfile = false
    }
    
    @MainActor
    private func setShowCount(count: Int?) {
        self.showsLoggedCount = count
        self.isLoadingShowCount = false
    }
    
    @MainActor
    private func setLoadingState() {
        self.isLoadingProfile = true
        self.isLoadingShowCount = true
        self.errorMessage = nil
        self.profile = nil
        self.showsLoggedCount = nil
    }
    
    func loadProfileData(id: String) async {
        await setLoadingState()
        
        async let profileTask = fetcherInstance.fetchProfile(userId: id)
        async let showCountTask = fetchShowsLoggedCount(userId: id)
        
        do {
            let (fetchedProfile, fetchedShowCount) = try await (profileTask, showCountTask)
            await setProfile(profile: fetchedProfile)
            await setShowCount(count: fetchedShowCount)
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load profile data: \(error.localizedDescription)"
                self.isLoadingProfile = false
                self.isLoadingShowCount = false
            }
            dump(error)
        }
    }
    
    /*
    func loadProfile(id: String) async {
        do {
            let fetched = try await fetcherInstance.fetchProfile(userId: id)
            if (fetched != nil) { await setProfile(profile: fetched!) }
        } catch {
            dump(error)
        }
    }
    */
}

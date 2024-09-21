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
    
    let fetcherInstance = ProfileFetcher.shared
    
    @MainActor
    func setProfile(profile: Profile) {
        self.profile = profile
    }
    
    func loadProfile(id: String) async {
        do {
            let fetched = try await fetcherInstance.fetchProfile(userId: id)
            if (fetched != nil) { await setProfile(profile: fetched!) }
        } catch {
            dump(error)
        }
    }
    
}

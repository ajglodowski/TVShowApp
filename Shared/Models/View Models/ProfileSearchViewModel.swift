//
//  ProfileSearchViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ProfileSearchViewModel: ObservableObject {
    
    @Published var profilesReturned: [Profile] = [Profile]()
    
    private var store = Storage.storage().reference()
    
    @MainActor
    func setProfilesReturned(profiles: [Profile]) {
        self.profilesReturned = profiles
    }
    
    func searchForUser(username: String) async {
        if (username.isEmpty) { return }
        let fetched = await findProfileByName(searchText: username)
        await setProfilesReturned(profiles: fetched)
    }
    
}

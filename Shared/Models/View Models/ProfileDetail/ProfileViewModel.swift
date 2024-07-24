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
    @Published var profilePic: Image? = nil
    
    //private var ref: DatabaseReference = Database.database().reference()
    //private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    @MainActor
    func loadProfile(modelData: ModelData, id: String) async {
        if (modelData.profiles[id] != nil && modelData.profilePics[id] != nil) {
            self.profile = modelData.profiles[id]
            self.profilePic = modelData.profilePics[id]
            return
        }
        if (modelData.loadingProfiles.contains(id)) { return }
        modelData.loadingProfiles.insert(id)
        //print("Loading profile: \(id)")
        do {
            let fetchedProfile: SupabaseProfile = try await supabase
                .from("user")
                .select(SupabaseProfileProperties)
                .eq("id", value: id)
                .single()
                .execute()
                .value
            let prof = Profile(from: fetchedProfile)
            modelData.profiles[prof.id] = prof
            
            // Loading Profile Pic
            var imageUrl = prof.profilePhotoURL
            if (prof.profilePhotoURL == nil) { imageUrl = "blank.jpg" }
            let picRef = self.store.child("profilePics/\(imageUrl!)")
            picRef.getData(maxSize: 2 * 1024 * 1024) { data, error in // 2 MB
                if let error = error {
                    //print(error.localizedDescription)
                } else {
                    let profImage = UIImage(data: data!)!
                    self.profilePic = Image(uiImage: profImage)
                    modelData.profilePics[id] = Image(uiImage: profImage)
                }
            }
        } catch {
            dump(error)
        }
        modelData.loadingProfiles.remove(id)
    }
    
}

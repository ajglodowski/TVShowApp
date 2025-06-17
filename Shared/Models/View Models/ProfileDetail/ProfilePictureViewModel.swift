//
//  ProfilePictureViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/4/24.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ProfilePictureViewModel: ObservableObject {
    
    @Published var profilePicture: UIImage? = nil
    
    let fetcherInstance = ProfilePictureFetcher.shared
    
    @MainActor
    func setProfilePicture(image: UIImage?) {
        self.profilePicture = image
    }

    func loadImage(userId: String, imageURL: String? = nil) async {
        do {
            let fetchedImage = try await fetcherInstance.fetchImage(userId: userId)
            await setProfilePicture(image: fetchedImage)
        } catch {
            dump(error)
        }
    }

}

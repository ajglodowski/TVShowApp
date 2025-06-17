//
//  ImageFunctions.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/5/24.
//

import Foundation
import UIKit
import FirebaseStorage

private var store = Storage.storage().reference()

func fetchProfilePicture(userId: String, imageUrl: String? = nil) async throws -> UIImage? {
    var fetchedProfilePicUrl: String?
    if (imageUrl == nil) { fetchedProfilePicUrl = await fetchProfilePicUrl(userId: userId) }
    if (fetchedProfilePicUrl == nil) { fetchedProfilePicUrl = "blank.jpg" }
    
    return try await withCheckedThrowingContinuation { continuation in
        let picRef = store.child("profilePics/\(fetchedProfilePicUrl!)")
        picRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                continuation.resume(throwing: error)
            } else if let data = data, let image = UIImage(data: data) {
                continuation.resume(returning: image)
            } else {
                let unknownError = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                continuation.resume(throwing: unknownError)
            }
        }
    }
}

func fetchShowTileImage(pictureUrl: String) async throws -> UIImage? {
    return try await withCheckedThrowingContinuation { continuation in
        let picRef = store.child("showImages/resizedImages/\(pictureUrl)_200x200.jpeg")
        picRef.getData(maxSize: 1 * 512 * 1024) { data, error in // 0.5 MB Max
            if let error = error {
                if !error.localizedDescription.contains("does not exist.") {
                    //print(error.localizedDescription)
                }
                continuation.resume(throwing: error)
            } else if let data = data, let image = UIImage(data: data) {
                continuation.resume(returning: image)
            } else {
                let unknownError = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                continuation.resume(throwing: unknownError)
            }
        }
    }
}

func fetchShowDetailImage(pictureUrl: String) async throws -> UIImage? {
    return try await withCheckedThrowingContinuation { continuation in
        let picRef = store.child("showImages/resizedImages/\(pictureUrl)_640x640.jpeg")
        picRef.getData(maxSize: 1 * 1024 * 1024) { data, error in // 1.0 MB Max
            if let error = error {
                if !error.localizedDescription.contains("does not exist.") {
                    //print(error.localizedDescription)
                }
                continuation.resume(throwing: error)
            } else if let data = data, let image = UIImage(data: data) {
                continuation.resume(returning: image)
            } else {
                let unknownError = NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                continuation.resume(throwing: unknownError)
            }
        }
    }
}

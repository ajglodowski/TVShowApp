//
//  ShowDetailPhotoViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/13/22.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class ShowDetailPhotoCacheManager {
    
    static let instance = ShowDetailPhotoCacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 500
        cache.totalCostLimit = 1024 * 1024 * 1024 // 1 GB
        return cache
    }()
    
    var imagesLoading = Set<String>()
    
    func add(image: UIImage, pictureUrl: String) {
        imageCache.setObject(image, forKey: pictureUrl as NSString)
    }
    
    func remove(pictureUrl: String) {
        imageCache.removeObject(forKey: pictureUrl as NSString)
    }
    
    func get(pictureUrl: String) -> UIImage? {
        return imageCache.object(forKey: pictureUrl as NSString)
    }
    
}

class ShowDetailPhotoViewModel: ObservableObject {
    
    @Published var showImage: UIImage? = nil
    @Published var cachedShowImage: UIImage? = nil
    
    let cacheManager = ShowDetailPhotoCacheManager.instance
    
    private var store = Storage.storage().reference()
        
    @MainActor
    func setShowImage(image: UIImage?) {
        self.showImage = image
    }
    
    @MainActor
    func setCachedShowImage(image: UIImage?) {
        self.cachedShowImage = image
    }

    func loadImage(pictureUrl: String) async {
        await self.getFromCache(pictureUrl: pictureUrl)
        if (cachedShowImage == nil) {
            do {
//                let fetchedImage = try await fetchFromFirebase(showName: showName)
                let fetchedImage = try await fetchShowDetailImage(pictureUrl: pictureUrl)
                if (fetchedImage != nil) {
                    await setShowImage(image: fetchedImage)
                    self.saveToCache(pictureUrl: pictureUrl)
                }
            } catch {
                //dump(error)
            }
        } else {
            await setShowImage(image: self.cachedShowImage)
        }
    }
    
    func fetchFromFirebase(showName: String) async throws -> UIImage? {
        return try await withCheckedThrowingContinuation { continuation in
            let picRef = self.store.child("showImages/resizedImages/\(showName)_640x640.jpeg")
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
    
    func saveToCache(pictureUrl: String) {
        guard let image = self.showImage else { return }
        cacheManager.add(image: image, pictureUrl: pictureUrl)
    }
    
    func removeFromCache(pictureUrl: String) {
        cacheManager.remove(pictureUrl: pictureUrl)
    }
    
    func getFromCache(pictureUrl: String) async {
        await setShowImage(image: cacheManager.get(pictureUrl: pictureUrl))
    }
    
}


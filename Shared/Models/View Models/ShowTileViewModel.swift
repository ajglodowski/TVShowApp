//
//  ShowTileViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase
import FirebaseStorage

class ShowTileCacheManager {
    
    static let instance = ShowTileCacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 500
        cache.totalCostLimit = 1024 * 1024 * 1024 // 1 GB
        return cache
    }()
    
    var imagesLoading = Set<String>()
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
    
}

class ShowTileViewModel: ObservableObject {
    
    @Published var showImage: UIImage? = nil
    @Published var cachedShowImage: UIImage? = nil
    
    let cacheManager = ShowTileCacheManager.instance
    
    private var store = Storage.storage().reference()
        
    @MainActor
    func setShowImage(image: UIImage?) {
        self.showImage = image
    }
    
    @MainActor
    func setCachedShowImage(image: UIImage?) {
        self.cachedShowImage = image
    }

    func loadImage(showName: String) async {
        await self.getFromCache(showName: showName)
        if (cachedShowImage == nil) {
            do {
                let fetchedImage = try await fetchFromFirebase(showName: showName)
                if (fetchedImage != nil) {
                    await setShowImage(image: fetchedImage)
                    self.saveToCache(showName: showName)
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
            let picRef = self.store.child("showImages/resizedImages/\(showName)_200x200.jpeg")
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
    
    func saveToCache(showName: String) {
        guard let image = self.showImage else { return }
        cacheManager.add(image: image, name: showName)
    }
    
    func removeFromCache(showName: String) {
        cacheManager.remove(name: showName)
    }
    
    func getFromCache(showName: String) async {
        await setShowImage(image: cacheManager.get(name: showName))
    }
    
}

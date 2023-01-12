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
    
    //private var ref: DatabaseReference = Database.database().reference()
    private var fireStore = Firebase.Firestore.firestore()
    private var store = Storage.storage().reference()
    
    //@MainActor
    func loadImage(showName: String) {
        //fireStore.clearPersistence()
        self.getFromCache(showName: showName)
        if (cachedShowImage == nil) {
            //print("Doing a fetch for \(showName)")
            DispatchQueue.global().async {
                let picRef = self.store.child("showImages/resizedImages/\(showName)_200x200.jpeg")
                picRef.getData(maxSize: 1 * 512 * 1024) { data, error in // 0.5 MB Max
                    if let error = error {
                        if (!error.localizedDescription.contains("does not exist.")) {
                            print(error.localizedDescription)
                        }
                    } else {
                        let profImage = UIImage(data: data!)!
                        DispatchQueue.main.async {
                            self.showImage = profImage
                            self.saveToCache(showName: showName)
                        }
                    }
                }
            }
        } else {
            //print("Using cache")
            self.showImage = self.cachedShowImage
        }
    }
    
    
    func saveToCache(showName: String) {
        guard let image = self.showImage else { return }
        cacheManager.add(image: image, name: showName)
    }
    
    func removeFromCache(showName: String) {
        cacheManager.remove(name: showName)
    }
    
    func getFromCache(showName: String) {
        self.cachedShowImage = cacheManager.get(name: showName)
    }
    
}

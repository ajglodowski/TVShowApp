//
//  ShowTileImageFetcher.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/5/24.
//

import Foundation
import UIKit

actor ShowTileImageFetchTaskManager {
    private var fetchTasks: [String: Task<UIImage?, Error>] = [:]

    func get(pictureUrl: String) -> Task<UIImage?, Error>? {
        return self.fetchTasks[pictureUrl]
    }

    func add(_ task: Task<UIImage?, Error>, pictureUrl: String) {
        self.fetchTasks[pictureUrl] = task
    }

    func remove(pictureUrl: String) {
        self.fetchTasks[pictureUrl] = nil
    }
}

class ShowTileImageFetcher {
    
    static let shared = ShowTileImageFetcher()
    
    private var fetchTasks: [String: Task<UIImage?, Error>] = [:]

    private let cache = ShowTileCacheManager.instance
    
    private let taskManager = ShowTileImageFetchTaskManager()
    
    func fetchImage(pictureUrl: String) async throws -> UIImage? {
        let cachedImage = cache.get(name: pictureUrl)
        if (cachedImage != nil) { return cachedImage }

        let existingTask = await taskManager.get(pictureUrl: pictureUrl)
        if (existingTask != nil) { return try await existingTask!.value }

        let task = Task { () -> UIImage? in
            defer {
                Task {
                    await self.taskManager.remove(pictureUrl: pictureUrl)
                }
            }
            let image = try await fetchShowTileImage(pictureUrl:pictureUrl)
            if (image != nil) { self.cache.add(image: image!, name: pictureUrl) }
            return image
        }
        await taskManager.add(task, pictureUrl: pictureUrl)

        return try await task.value
    }
    
}

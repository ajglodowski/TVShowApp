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

    func get(showName: String) -> Task<UIImage?, Error>? {
        return self.fetchTasks[showName]
    }

    func add(_ task: Task<UIImage?, Error>, showName: String) {
        self.fetchTasks[showName] = task
    }

    func remove(showName: String) {
        self.fetchTasks[showName] = nil
    }
}

class ShowTileImageFetcher {
    
    static let shared = ShowTileImageFetcher()
    
    private var fetchTasks: [String: Task<UIImage?, Error>] = [:]

    private let cache = ShowTileCacheManager.instance
    
    private let taskManager = ShowTileImageFetchTaskManager()
    
    func fetchImage(showName: String) async throws -> UIImage? {
        let cachedImage = cache.get(name: showName)
        if (cachedImage != nil) { return cachedImage }

        let existingTask = await taskManager.get(showName: showName)
        if (existingTask != nil) { return try await existingTask!.value }

        let task = Task { () -> UIImage? in
            defer {
                Task {
                    await self.taskManager.remove(showName: showName)
                }
            }
            let image = try await fetchShowTileImage(showName:showName)
            if (image != nil) { self.cache.add(image: image!, name: showName) }
            return image
        }
        await taskManager.add(task, showName: showName)

        return try await task.value
    }
    
}

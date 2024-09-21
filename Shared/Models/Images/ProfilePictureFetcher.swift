//
//  ProfilePictureFetcher.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/5/24.
//

import Foundation
import UIKit

actor ProfilePictureFetchTaskManager {
    private var fetchTasks: [String: Task<UIImage?, Error>] = [:]

    func get(userId: String) -> Task<UIImage?, Error>? {
        return self.fetchTasks[userId]
    }

    func add(_ task: Task<UIImage?, Error>, userId: String) {
        self.fetchTasks[userId] = task
    }

    func remove(userId: String) {
        self.fetchTasks[userId] = nil
    }
}

class ProfilePictureFetcher {
    
    static let shared = ProfilePictureFetcher()
    
    private var fetchTasks: [String: Task<UIImage?, Error>] = [:]

    private let cache = ProfilePictureCacheManager.instance
    
    private let taskManager = ProfilePictureFetchTaskManager()
    
    func fetchImage(userId: String) async throws -> UIImage? {
        let cachedImage = cache.get(userId: userId)
        if (cachedImage != nil) { return cachedImage }

        let existingTask = await taskManager.get(userId: userId)
        if (existingTask != nil) { return try await existingTask!.value }

        let task = Task { () -> UIImage? in
            defer {
                Task {
                    await self.taskManager.remove(userId: userId)
                }
            }
            let image = try await fetchProfilePicture(userId:userId)
            if (image != nil) { self.cache.add(image: image!, userId: userId) }
            return image
        }
        await taskManager.add(task, userId: userId)

        return try await task.value
    }
    
}

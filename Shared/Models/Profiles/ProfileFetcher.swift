//
//  ProfileFetcher.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/11/24.
//

import Foundation

actor ProfileFetchTaskManager {
    private var fetchTasks: [String: Task<Profile?, Error>] = [:]

    func get(userId: String) -> Task<Profile?, Error>? {
        return self.fetchTasks[userId]
    }

    func add(_ task: Task<Profile?, Error>, userId: String) {
        self.fetchTasks[userId] = task
    }

    func remove(userId: String) {
        self.fetchTasks[userId] = nil
    }
}

class ProfileFetcher {
    
    static let shared = ProfileFetcher()
    
    private var fetchTasks: [String: Task<Profile?, Error>] = [:]

    private let cache = ProfileCacheManager.instance
    
    private let taskManager = ProfileFetchTaskManager()
    
    func fetchProfile(userId: String) async throws -> Profile? {
        let cachedProfile = cache.get(userId: userId)
        if (cachedProfile != nil) { return cachedProfile }

        let existingTask = await taskManager.get(userId: userId)
        if (existingTask != nil) { return try await existingTask!.value }

        let task = Task { () -> Profile? in
            defer {
                Task {
                    await self.taskManager.remove(userId: userId)
                }
            }
            let profile = try await fetchProfileInfo(userId:userId)
            if (profile != nil) { self.cache.add(profile: profile!, userId: userId) }
            return profile
        }
        await taskManager.add(task, userId: userId)

        return try await task.value
    }
    
}

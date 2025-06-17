//
//  StatusService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/24/24.
//

import Foundation

func fetchAllStatuses() async -> [Status] {
    do {
        let fetchedStatuses: [Status] = try await supabase
            .from("status")
            .select(StatusProperties)
            .execute()
            .value
        return fetchedStatuses
    } catch {
        dump(error)
        return []
    }
}

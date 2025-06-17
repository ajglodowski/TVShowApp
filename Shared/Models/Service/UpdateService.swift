//
//  UpdateService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/6/24.
//

import Foundation

func getShowUpdatesForUsers(showId: Int, userIds: [String]) async -> [UserUpdate]? {
    do {
        let fetchedDetails: [SupabaseUserUpdate] = try await supabase
            .from("UserUpdate")
            .select(SupabasUserUpdateProperties)
            .match(["showId": showId])
            .in("userId", values: userIds)
            .execute()
            .value
        let convertedDetails = fetchedDetails.map { UserUpdate(from: $0) }
        return convertedDetails
    } catch {
        dump(error)
        return nil
    }
}

func getMostRecentUpdates(userIds: [String]) async -> [UserUpdate]? {
    do {
        let fetchedDetails: [SupabaseUserUpdate] = try await supabase
            .from("UserUpdate")
            .select(SupabasUserUpdateProperties)
            .in("userId", values: userIds)
            .order("updateDate", ascending: false)
            .limit(10)
            .execute()
            .value
        let convertedDetails = fetchedDetails.map { UserUpdate(from: $0) }
        return convertedDetails
    } catch {
        dump(error)
        return nil
    }
}

struct UserFollowRelationshipId: Codable {
    let followingUserId: String
}

func getFriendIds(userId: String) async -> [String]? {
    do {
        let fetchedDetails: [UserFollowRelationshipId] = try await supabase
            .from("UserFollowRelationship")
            .select("followingUserId")
            .match(["followerUser": userId, "pending": false])
            .execute()
            .value
        return fetchedDetails.map { $0.followingUserId }
    } catch {
        dump(error)
        return nil
    }
}

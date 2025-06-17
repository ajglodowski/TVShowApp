//
//  ProfileService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/4/24.
//

import Foundation

func findProfileByName(searchText: String) async -> [Profile] {
    do {
        let foundProfs: [SupabaseProfile] = try await supabase
            .from("user")
            .select(SupabaseProfileProperties)
            .ilike("username", pattern: "%\(searchText)%")
            .limit(5)
            .execute()
            .value
        let converted: [Profile] = foundProfs.map { Profile(from: $0) }
        return converted
    } catch {
        dump(error)
        return []
    }
}

func fetchProfileInfo(userId: String) async -> Profile? {
    do {
        // Fetch basic profile
        let fetchedProfile: SupabaseProfile = try await supabase
            .from("user")
            .select(SupabaseProfileProperties)
            .eq("id", value: userId)
            .single()
            .execute()
            .value

        // Fetch follower count
        let followerCountResponse = try await supabase
            .from("UserFollowRelationship")
            .select("*", head: true, count: .exact) // Use head: true for count only
            .eq("followingUserId", value: userId)
            .execute()
        let followerCount = followerCountResponse.count

        // Fetch following count
        let followingCountResponse = try await supabase
            .from("UserFollowRelationship")
            .select("*", head: true, count: .exact) // Use head: true for count only
            .eq("followerUser", value: userId)
            .execute()
        let followingCount = followingCountResponse.count

        // Initialize Profile and add counts
        var prof = Profile(from: fetchedProfile)
        prof.followerCount = followerCount
        prof.followingCount = followingCount

        return prof
    } catch {
        // Consider more specific error handling or logging
        dump(error) // Keep dump for now, but might remove later
        return nil
    }
}

struct ProfilePicDTO: Codable {
    var profilePhotoURL: String
}

func fetchProfilePicUrl(userId: String) async -> String? {
    do {
        let fetchedURL: ProfilePicDTO = try await supabase
            .from("user")
            .select("profilePhotoURL")
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        return fetchedURL.profilePhotoURL
    } catch {
        dump(error)
        return nil
    }
}

// MARK: - User Basic Info for Lists
struct UserBasicInfo: Identifiable, Codable, Hashable {
    var id: String
    var username: String
    var profilePhotoURL: String?
    
    // Add CodingKeys if JSON keys differ, e.g., profile_photo_url
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profilePhotoURL = "profilePhotoURL"
    }
}

// MARK: - Follower/Following List Fetching

// Helper struct to decode the nested user data from the relationship query
struct FollowerUserRelation: Decodable, Hashable {
    let user: UserBasicInfo
    
    enum CodingKeys: String, CodingKey {
        case user = "followerUser"
    }
}

struct FollowingUserRelation: Decodable, Hashable {
    let user: UserBasicInfo
    
    enum CodingKeys: String, CodingKey {
        case user = "followingUserId"
    }
}

func fetchFollowerList(userId: String) async -> [UserBasicInfo]? {
    do {
        // Query UserFollowRelationship, selecting the nested followerUser's details
        let response: [FollowerUserRelation] = try await supabase
            .from("UserFollowRelationship")
            // Specify the foreign key constraint for the join
            .select("followerUser:user!UserFollowRelationship_followerUser_fkey(id, username, profilePhotoURL)")
            .eq("followingUserId", value: userId)
            .execute()
            .value
        // Extract the UserBasicInfo objects
        let users = response.map { $0.user }
        return users
    } catch {
        dump(error)
        return nil
    }
}

func fetchFollowingList(userId: String) async -> [UserBasicInfo]? {
    do {
        // Query UserFollowRelationship, selecting the nested followingUserId's details
        let response: [FollowingUserRelation] = try await supabase
            .from("UserFollowRelationship")
             // Specify the foreign key constraint for the join
            .select("followingUserId:user!UserFollowRelationship_followingUserId_fkey(id, username, profilePhotoURL)")
            .eq("followerUser", value: userId)
            .execute()
            .value
        // Extract the UserBasicInfo objects
        let users = response.map { $0.user }
        return users
    } catch {
        dump(error)
        return nil
    }
}

// MARK: - Show Count Fetching
func fetchShowsLoggedCount(userId: String) async -> Int? {
    do {
        let response = try await supabase
            .from("UserShowDetails")
            .select("*", head: true, count: .exact)
            .eq("userId", value: userId)
            .execute()
        return response.count
    } catch {
        dump(error)
        return nil // Return nil on error
    }
}


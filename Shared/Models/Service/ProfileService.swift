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
        let fetchedProfile: SupabaseProfile = try await supabase
            .from("user")
            .select(SupabaseProfileProperties)
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        let prof = Profile(from: fetchedProfile)
        return prof
    } catch {
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

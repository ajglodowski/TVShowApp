//
//  MultiUserShowService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import Foundation
import Supabase

// MARK: - Multi-User Show Data Fetching

func getFriendsUserDetailsForShow(showId: Int) async -> [UserShowDataWithUserInfo]? {
    guard let currentUserId = supabase.auth.currentUser?.id.uuidString else {
        return nil
    }
    
    do {
        // Call the same RPC function as the NextJS app
        let response = try await supabase
            .rpc("get_following_user_details_for_show", params: [
                "inputuserid": currentUserId.lowercased(),
                "inputshowid": String(showId)
            ])
            .execute()
        
        // Parse the response similar to NextJS implementation
        // Handle case where RPC returns null or empty result
        if response.data == nil {
            return []
        }
        
        // Decode the raw Data into JSON
        guard let responseData = response.data as? Data else {
            return []
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
            
            // Handle null response
            if jsonObject is NSNull {
                return []
            }
            
            guard let data = jsonObject as? [[String: Any]] else {
                return []
            }
            
            if data.isEmpty {
                return []
            }
            
            let results = data.compactMap { row -> UserShowDataWithUserInfo? in
                guard let userId = row["userid"] as? String else {
                    return nil
                }
                
                guard let username = row["username"] as? String else {
                    return nil
                }
                
                guard let statusId = row["status"] as? Int else {
                    return nil
                }
                
                guard let statusName = row["statusname"] as? String else {
                    return nil
                }
                
                guard let currentSeason = row["currentseason"] as? Int else {
                    return nil
                }
                
                guard let updatedString = row["updated"] as? String else {
                    return nil
                }
                
                let user = UserBasicInfo(
                    id: userId,
                    username: username,
                    profilePhotoURL: row["profilephotourl"] as? String
                )
                
                // Create Status with required fields (using current date for missing fields)
                let status = Status(id: statusId, name: statusName, created_at: Date(), update_at: Date())
                // Handle rating as String enum
                let rating = (row["rating"] as? String).flatMap { Rating(rawValue: $0) }
                
                // Parse the date string
                let dateFormatter = ISO8601DateFormatter()
                let updated = dateFormatter.date(from: updatedString) ?? Date()
                
                let showDetails = ShowUserSpecificDetails(
                    userId: userId,
                    showId: showId,
                    status: status,
                    updated: updated,
                    currentSeason: currentSeason,
                    rating: rating
                )
                let out = UserShowDataWithUserInfo(user: user, showDetails: showDetails)
                return out
            }
            
            return results
        } catch {
            return []
        }
    } catch {
        return nil
    }
}

func getCurrentUsersShowDetails(showId: Int) async -> UserShowDataWithUserInfo? {
    guard let currentUserId = supabase.auth.currentUser?.id.uuidString else {
        return nil
    }
    
    do {
        // Fetch user show details with joined user info
        let response = try await supabase
            .from("UserShowDetails")
            .select("*, user:userId(id, username, profilePhotoURL), status_info:status(id, name)")
            .match(["userId": currentUserId, "showId": String(showId)])
            .limit(1)
            .execute()
        
        // Decode the raw Data into JSON
        guard let responseData = response.data as? Data else {
            return nil
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
            
            // Handle null response
            if jsonObject is NSNull {
                return nil
            }
            
            guard let dataArray = jsonObject as? [[String: Any]] else {
                return nil
            }
            
            if dataArray.isEmpty {
                return nil
            }
            
            let data = dataArray[0]
            
            // Extract user info
            guard let userDict = data["user"] as? [String: Any],
                  let userId = userDict["id"] as? String,
                  let username = userDict["username"] as? String else {
                return nil
            }
            
            let user = UserBasicInfo(
                id: userId,
                username: username,
                profilePhotoURL: userDict["profilePhotoURL"] as? String
            )
            
            // Extract status info
            guard let statusDict = data["status_info"] as? [String: Any],
                  let statusId = statusDict["id"] as? Int,
                  let statusName = statusDict["name"] as? String else {
                return nil
            }
            
            // Create Status with required fields (using current date for missing fields)
            let status = Status(id: statusId, name: statusName, created_at: Date(), update_at: Date())
            
            // Extract other details
            guard let currentSeason = data["currentSeason"] as? Int,
                  let updatedString = data["updated"] as? String else {
                return nil
            }
            
            // Handle rating as String enum
            let rating = (data["rating"] as? String).flatMap { Rating(rawValue: $0) }
            
            // Parse the date string
            let dateFormatter = ISO8601DateFormatter()
            let updated = dateFormatter.date(from: updatedString) ?? Date()
            
            let showDetails = ShowUserSpecificDetails(
                userId: userId,
                showId: showId,
                status: status,
                updated: updated,
                currentSeason: currentSeason,
                rating: rating
            )
            
            return UserShowDataWithUserInfo(user: user, showDetails: showDetails)
        } catch {
            return nil
        }
    } catch {
        dump(error)
        return nil
    }
}

func getMultiUserShowData(showId: Int) async -> ShowMultiUserData {
    async let currentUserTask = getCurrentUsersShowDetails(showId: showId)
    async let friendsTask = getFriendsUserDetailsForShow(showId: showId)
    
    let (currentUser, friends) = await (currentUserTask, friendsTask)
    
    return ShowMultiUserData(
        showId: showId,
        currentUserData: currentUser,
        otherUsersData: friends ?? []
    )
} 

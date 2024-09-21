//
//  UserDetailsService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/4/24.
//

import Foundation
import PostgREST

func getUserShowData(showId: Int, userId: String?) async -> ShowUserSpecificDetails? {
    if (userId == nil) { return nil }
    do {
        let fetchedDetails: SupabaseShowUserDetails = try await supabase
            .from("UserShowDetails")
            .select(SupabaseShowUserDetailsProperties)
            .match(["userId": userId!, "showId": showId])
            .single()
            .execute()
            .value
        dump(fetchedDetails)
        let converted = ShowUserSpecificDetails(from: fetchedDetails)
        dump(converted)
        return converted
    } catch {
        dump(error)
        return nil
    }
}

 func updateCurrentSeason(showId: Int, userId: String, newSeason: Int) async -> Bool {
     do {
         try await supabase
             .from("UserShowDetails")
             .update(["currentSeason": newSeason])
             .match(["userId": userId, "showId": showId])
             .execute()
         return true;
     } catch {
         dump(error)
         return false
     }
}

func updateStatus(showId: Int, userId: String, newStatus: Status) async -> Bool {
    do {
       try await supabase
            .from("UserShowDetails")
            .update(["status": newStatus.id])
            .match(["userId": userId, "showId": showId])
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func getAllStatuses() async -> [Status] {
    do {
        let data: [Status] = try await supabase
            .from("status")
            .select()
            .execute()
            .value
        return data
    } catch {
        dump(error)
        return []
    }
}

func getUserUpdates(showId: Int, userId: String?) async -> [UserUpdate] {
    if (userId == nil) { return []; }

    do {
        let fetchedDetails: [SupabaseUserUpdate] = try await supabase
            .from("UserUpdate")
            .select(SupabasUserUpdateProperties)
            .eq("userId", value: userId)
            .execute()
            .value
        return fetchedDetails.map { UserUpdate(from: $0) }
    } catch {
        dump(error)
        return []
    }
}

func updateRating(showId: Int, userId: String, newRating: Rating?) async -> Bool{
    do {
        if (newRating != nil) {
            try await supabase
                .from("UserShowDetails")
                .update(["rating": newRating])
                .match(["userId": userId, "showId": showId])
                .execute()
        } else {
            try await supabase
                .from("UserShowDetails")
                .update(["rating": "nil"]) // FIXME
                .match(["userId": userId, "showId": showId])
                .execute()
        }
        return true
    } catch {
        dump(error)
        return false
    }
}

enum EncodableValue: Encodable {
    case string(String)
    case int(Int)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        }
    }
}

func addToWatchList(showId: Int, userId: String) async -> Bool {
    do {
        let insertData: [String : EncodableValue] = ["userId": .string(userId), "showId": .int(showId), "currentSeason": .int(1), "status": .int(NeedsWatchedStatusId)]
        try await supabase
            .from("UserShowDetails")
            .insert(insertData)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func updateUserShowData(updateType: UserUpdateCategory, userId: String, showId: Int, seasonChange: Int?, ratingChange: Rating?, statusChange: Status?) async -> Bool {
    var response = true;
    var update: SupabaseUserUpdate? = nil;
    switch (updateType) {
        case UserUpdateCategory.AddedToWatchlist:
            response = await addToWatchList(showId: showId, userId: userId)
            if (response) {
                update = SupabaseUserUpdate(id: -1, updateDate: Date(), userId: userId, showId: showId, updateType: UserUpdateCategory.AddedToWatchlist)
            }
            break;
        case UserUpdateCategory.ChangedRating:
            response = await updateRating(showId: showId, userId: userId, newRating: ratingChange);
            if (response) {
                update = SupabaseUserUpdate(id: -1, updateDate: Date(), userId: userId, showId: showId, ratingChange: ratingChange, updateType: UserUpdateCategory.ChangedRating)
            }
            break;
        case UserUpdateCategory.ChangedSeason:
            if (seasonChange == nil) { break; }
            response = await updateCurrentSeason(showId: showId, userId: userId, newSeason: seasonChange!)
            if (response) {
                update = SupabaseUserUpdate(id: -1, updateDate: Date(), userId: userId, showId: showId, seasonChange: seasonChange, updateType: UserUpdateCategory.ChangedSeason)
            }
            break;
        case UserUpdateCategory.RemovedFromWatchlist:
            // TODO
            break;
        case UserUpdateCategory.RemovedRating:
            response = await updateRating(showId: showId, userId: userId, newRating: ratingChange)
            if (response) {
                update = SupabaseUserUpdate(id: -1, updateDate: Date(), userId: userId, showId: showId, updateType: UserUpdateCategory.RemovedRating)
            }
            break;
        case UserUpdateCategory.UpdatedStatus:
            if (statusChange == nil) { break; }
            response = await updateStatus(showId: showId, userId: userId, newStatus: statusChange!)
        if (response) {
            update = SupabaseUserUpdate(id: -1, updateDate: Date(), userId: userId, showId: showId, statusChange: statusChange, updateType: UserUpdateCategory.UpdatedStatus)
            }
            break;
        default:
            response = false;
            break;
    }
    if (update != nil && response) {
        response = await insertUpdate(update: update!);
    }
    return response

}

func insertUpdate(update: SupabaseUserUpdate) async -> Bool {
    do {
        let insertData = SupabaseUserUpdateInsert(from: update)
        try await supabase
            .from("UserUpdate")
            .insert(insertData)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

struct ShowsByStatusDto: Codable {
    var show: SupabaseShow
}

func getShowsForUserByStatus(statusId: Int? = nil, limit: Int? = nil, userId: String) async -> [Show] {
    do {
        var query = supabase
            .from("UserShowDetails")
            .select("show (\(SupabaseShowProperties))")
            .eq("userId", value: userId)
        if (statusId != nil) {
            query = query.eq("status", value: statusId!)
        }
        if (limit != nil) {
            query = query.limit(limit!) as! PostgrestFilterBuilder
        }
        query = query.order("updated", ascending: false) as! PostgrestFilterBuilder
        let fetchedDtos: [ShowsByStatusDto] = try await query
            .execute()
            .value
        return fetchedDtos.map { Show(from: $0.show) }
    } catch {
        dump(error)
        return []
    }
}

//
//  ShowService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/11/24.
//

import Foundation

func getShow(showId: Int) async -> Show? {
    do {
        let fetchedShow: SupabaseShow = try await supabase
            .from("show")
            .select(SupabaseShowProperties)
            .eq("id", value: showId)
            .single()
            .execute()
            .value
        let converted = Show(from: fetchedShow)
        return converted
    } catch {
        dump(error)
        return nil
    }
}

func addTagToShow(showId: Int, tagId: Int) async -> Bool {
    do {
        try await supabase
            .from("ShowTagRelationship")
            .insert(["showId": showId, "tagId": tagId])
            .execute()
        return true;
    } catch {
        dump(error)
        return false
    }
}

func removeTagFromShow(showId: Int, tagId: Int) async -> Bool {
    do {
        try await supabase
            .from("ShowTagRelationship")
            .delete()
            .match(["showId": showId, "tagId": tagId])
            .execute()
        return true;
    } catch {
        dump(error)
        return false
    }
}

func getTagsForShow(showId: Int) async -> [Tag]  {
    do {
        let fetchedTags: [ShowTagDTO] = try await supabase
            .from("ShowTagRelationship")
            .select(NestedTagProperties)
            .eq("showId", value: showId)
            .execute()
            .value
        let tagArray = fetchedTags.map { $0.showTag }
        return tagArray
    } catch {
        dump(error)
        return []
    }
}

func getActorsForShow(showId: Int) async -> [Actor]  {
    do {
        let fetchedDtos: [SupabaseActorShowRelationship] = try await supabase
            .from("ActorShowRelationship")
            .select(SupabaseActorShowRelationshipProperties)
            .eq("showId", value: showId)
            .execute()
            .value
        let actorArray = fetchedDtos.map { $0.actor }
        return actorArray
    } catch {
        dump(error)
        return []
    }
}

func getRatingCountsForShow(showId: Int) async -> [Rating:Int] {
    var output = [Rating:Int]()
    for rating in Rating.allCases { output[rating] = 0 }
    do {
        let fetchedDtos: [ShowRatingCountDto] = try await supabase
            .from("showratingcounts")
            .select(ShowRatingCountDtoProperties)
            .eq("showId", value: showId)
            .execute()
            .value
        for dto in fetchedDtos {
            output[dto.rating] = dto.count
        }
    } catch {
        dump(error)
    }
    return output
}

func getStatusCountsForShow(showId: Int) async -> [Status:Int] {
    var allStatuses = await fetchAllStatuses()
    var output = [Status:Int]()
    for status in allStatuses { output[status] = 0 }
    do {
        let fetchedDtos: [ShowStatusCountDto] = try await supabase
            .from("showstatuscounts")
            .select(ShowStatusCountDtoProperties)
            .eq("showId", value: showId)
            .execute()
            .value
        for dto in fetchedDtos {
            let foundStatus = allStatuses.first(where: { $0.id == dto.status })
            if (foundStatus != nil) {
                output[foundStatus!] = dto.count
            }
        }
    } catch {
        dump(error)
    }
    return output
}

func updateShow(show: SupabaseShow) async -> Bool {
    let updateDto = SupabaseShowUpdateDTO(from: show)
    do {
        try await supabase
            .from("show")
            .update(updateDto)
            .match(["id": show.id])
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func findShowByName(searchText: String) async -> [Show] {
    do {
        let foundShows: [SupabaseShow] = try await supabase
            .from("show")
            .select(SupabaseShowProperties)
            .ilike("name", pattern: "%\(searchText)%")
            .limit(5)
            .execute()
            .value
        let converted = foundShows.map { Show(from: $0) }
        return converted
    } catch {
        dump(error)
        return []
    }
}

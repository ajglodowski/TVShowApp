//
//  ActorService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/16/24.
//

import Foundation

func getActorInfo(actorId: Int) async -> Actor?  {
    do {
        let fetchedActor: Actor = try await supabase
            .from("actor")
            .select(ActorProperties)
            .eq("id", value: actorId)
            .single()
            .execute()
            .value
        return fetchedActor
    } catch {
        dump(error)
        return nil
    }
}

struct ShowsForActorDto: Codable {
    var actorId: Int
    var show: SupabaseShow
}

func getShowsForActor(actorId: Int) async -> [Show]  {
    do {
        let fetchedShows: [ShowsForActorDto] = try await supabase
            .from("ActorShowRelationship")
            .select("actorId, show (\(SupabaseShowProperties))")
            .eq("actorId", value: actorId)
            .execute()
            .value
        let showArray = fetchedShows.map { Show(from: $0.show) }
        return showArray
    } catch {
        dump(error)
        return []
    }
}

func updateActor(actor: Actor) async -> Bool {
    do {
        dump(actor)
        try await supabase
            .from("actor")
            .update(actor)
            .eq("id", value: actor.id)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

struct ActorShowRelationshipInsertDto {
    var showId: Int
    var actorId: Int
}

func addActorToShow(actorId: Int, showId: Int) async -> Bool {
    do {
        try await supabase
            .from("ActorShowRelationship")
            .insert(["showId": showId, "actorId": actorId])
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func removeActorFromShow(actorId: Int, showId: Int) async -> Bool {
    do {
        try await supabase
            .from("ActorShowRelationship")
            .delete()
            .match(["showId": showId, "actorId": actorId])
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

struct ActorInsertDto: Codable {
    var name: String
    init(from: Actor) {
        self.name = from.name
    }
}

func insertActor(actor: Actor, showId: Int) async -> Bool {
    do {
        let insert = ActorInsertDto(from: actor)
        let created: Actor = try await supabase
            .from("actor")
            .insert(insert)
            .select(ActorProperties)
            .single()
            .execute()
            .value
        return await addActorToShow(actorId: created.id, showId: showId)
    } catch {
        dump(error)
        return false
    }
    
}


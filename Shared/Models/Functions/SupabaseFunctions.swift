//
//  SupabaseFunctions.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 12/15/23.
//

import Foundation
/*
func convertShowToSupabaseShow(show:Show) -> SupabaseShow {
    return SupabaseShow(id: show.id, created_at: show.lastUpdated, lastUpdated: show.lastUpdated, name: show.name, service: MockSupabaseService, running: show.running, limitedSeries: show.limitedSeries, totalSeasons: show.totalSeasons, currentlyAiring: show.currentlyAiring, length: show.length)
}

func convertSupabaseShowToShow(show:SupabaseShow) -> Show {
    var out = Show(id: show.id)
    out.name = show.name
    out.lastUpdated =  show.lastUpdated
    out.running = show.running
    out.totalSeasons = show.totalSeasons
    out.currentlyAiring = show.currentlyAiring
    var service = Service(rawValue: show.service.name)
    if (service == nil) { service = Service.Other }
    out.service = service!
    out.limitedSeries = show.limitedSeries
    out.length = show.length
    out.airdate = show.airdate
    out.releaseDate = show.releaseDate
    
    return out
}
*/
/*
func addToUserShows(show: Show) {
    updateUserShow(show: show)
}

// Updating show properties in the current user's show collection
func updateToShows(show: Show) {
    let req = convertShowToSupabaseShow(show: show)
    try await supabase.database
      .from("show")
      .upsert(req)
      .execute()
}

func updateUserShow(show: Show) {
    let uid = "1"
    if (!show.addedToUserShows) { return }
    let req = convertToSupabaseShowUserDetails(show: show.userSpecificValues!)
    try await supabase.database
      .from("UserShowDetails")
      .upsert(req)
      .execute()
}

// Adding a new show to the shows collection
func addToShows(show: Show) {
    var req = convertShowToSupabaseShow(show: show)
    req.id = nil
    try await supabase.database
      .from("show")
      .insert(req)
      .execute()
}

func addActorToActors(act: Actor) {
    let req = SupabaseActor(name: act.name)
    try await supabase.database
      .from("actor")
      .insert(req)
      .execute()
}

func updateActor(act: Actor) {
    let req = SupabaseActor(name: act.name)
    try await supabase.database
      .from("actor")
      .upsert(req)
      .execute()
}
*/
/*
 // FIXME
func addTagToShow(showId: Int, tag: SupabaseTag) async {
    let req = SupabaseShowTagRelationship(showId: showId, tagId: tag.id)
     try await supabase
       .from("ShowTagRelationship")
       .upsert(req)
       .execute()
 }

func removeTagFromShow(remove: SupabaseShowTagRelationship) {
    try await supabase
      .from("ShowTagRelationship")
      .delete(remove)
      .execute()
 }
 */
/*

func updateCurrentSeason(newSeason: Int, showId: String) {
    let uid = "1"
    try await supabase.database
      .from("UserShowDetails")
      .update(["currentSeason": newSeason])
      .eq("showId", value: showId)
      .eq("userId", value: uid)
      .execute()
}

func updateRating(rating: Rating?, showId: String) {
    let uid = "1"
    try await supabase.database
      .from("UserShowDetails")
      .update(["Rating": rating?.rawValue ?? nil])
      .eq("showId", value: showId)
      .eq("userId", value: uid)
      .execute()
}

func deleteShowFromUserShows(showId: String) {
    let uid = "1"
    try await supabase.database
      .from("UserShowDetails")
      .delete()
      .eq("showId", value: showId)
      .eq("userId", value: uid)
      .execute()
}

func deleteRatingFromUserShows(showId: String) {
    updateRating(rating: nil, showId: showId)
}

func addActorToShow(act: Actor, showId: String) {
    let req = SupabaseActorShowRelationship(showId: showId, actorId: act.id)
    try await supabase.database
      .from("ActorShowRelationship")
      .insert(req)
      .execute()
}

func removeActorFromShow(actorId: String, showId: String) {
    try await supabase.database
      .from("UserShowDetails")
      .delete()
      .eq("showId", value: showId)
      .eq("actorId", value: actorId)
      .execute()
}

func setTotalSeasons(showId: String, totalSeasons: Int) {
    let cur
    try await supabase.database
      .from("show")
      .update(["totalSeasons": totalSeasons])
      .eq("showId", value: showId)
      .execute()
}
*/

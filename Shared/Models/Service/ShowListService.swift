//
//  ShowListService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/25/24.
//

import Foundation

func generateShowListEntrys(listId: Int, shows: [Show]) -> [SupabaseShowListEntryInsertDto] {
    var output = [SupabaseShowListEntryInsertDto]()
    for (index, show) in shows.enumerated() {
        let newEntry = SupabaseShowListEntryInsertDto(created_at: Date(), listId: listId, showId: show.id, position: index+1)
        output.append(newEntry)
    }
    return output
}

func showListEntryExists(showId: Int, listId: Int) async -> SupabaseShowListEntry? {
    do {
        let foundEntry: SupabaseShowListEntry?  = try await supabase
            .from("ShowListRelationship")
            .select(SupabaseShowListEntryProperties)
            .match(["listId": listId, "showId": showId])
            .single()
            .execute()
            .value
        return foundEntry
    } catch {
        dump(error)
        return nil
    }
}

func updateShowListEntry(entryId: Int, newEntry: SupabaseShowListEntryInsertDto) async -> Bool {
    do {
        try await supabase
            .from("ShowListRelationship")
            .update(newEntry)
            .match(["id": entryId])
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func insertShowListEntry(newEntry: SupabaseShowListEntryInsertDto) async -> Bool {
    do {
        try await supabase
            .from("ShowListRelationship")
            .upsert(newEntry)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func processSingleListEntryUpdate(entry: SupabaseShowListEntryInsertDto) async -> Bool {
    let listId = entry.listId
    let existingEntry = await showListEntryExists(showId: entry.showId, listId: listId)
    var updateSuccess = true
    if (existingEntry?.position != entry.position) {
        if (existingEntry != nil) {
            updateSuccess = await updateShowListEntry(entryId: existingEntry!.id, newEntry: entry)
        } else {
            updateSuccess = await insertShowListEntry(newEntry: entry)
        }
    }
    return updateSuccess
}

func getRemovedShows(originalShows: [Show], newShows: [Show]) -> [Show] {
    return originalShows.filter { original in
        !newShows.contains(where: { $0.id == original.id })
    }
}

func deleteRemovedShowsFromList(listId: Int, shows: [Show]) async -> Bool {
    let removedIds = shows.map { $0.id }
    do {
        try await supabase
            .from("ShowListRelationship")
            .delete()
            .eq("listId", value: listId)
            .in("showId", values: removedIds)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func updateListShows(listId: Int, shows: [Show], previousShows: [Show]) async -> Bool {
    
    let removedShows = getRemovedShows(originalShows: previousShows, newShows: shows)
    let removalSuccess = await deleteRemovedShowsFromList(listId: listId, shows: removedShows)
    if (!removalSuccess) { return false }

    let newEntries = generateShowListEntrys(listId: listId, shows: shows)
    var overallSuccess = true
    await withTaskGroup(of: Bool.self) { group in
        for entry in newEntries {
            group.addTask {
                await processSingleListEntryUpdate(entry: entry)
            }
        }

        for await singleUpdateSuccess in group {
            if (!singleUpdateSuccess) { overallSuccess = false }
        }
    }
    return overallSuccess
}

func updateListOrdered(listId: Int, listOrdered: Bool) async -> Bool {
    do {
        try await supabase
            .from("showList")
            .update(["ordered": listOrdered])
            .eq("id", value: listId)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

func updateShowListInfo(showList: ShowList) async -> Bool {
    let converted = SupabaseShowList(from: showList)
    do {
        try await supabase
            .from("showList")
            .update(converted)
            .eq("id", value: converted.id)
            .execute()
        return true
    } catch {
        dump(error)
        return false
    }
}

//
//  ShowListViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase

class ShowListViewModel: ObservableObject {
    
    @Published var showListObj: ShowList? = nil
    
    @MainActor
    func setShowList(showList: ShowList) {
        self.showListObj = showList
    }
    
    func fetchList(id: Int) async -> SupabaseShowList? {
        do {
            let fetchedList: SupabaseShowList = try await supabase
                .from("showList")
                .select(SupabaseShowListProperties)
                .match(["id": id])
                .single()
                .execute()
                .value
            return fetchedList
        } catch {
            dump(error)
            return nil
        }
    }
    
    func fetchEntries(id: Int, showLimit: Int? = nil) async -> [SupabaseShowListEntry]? {
        do {
            var fetchQuery = supabase
                .from("ShowListRelationship")
                .select(SupabaseShowListEntryProperties)
                .match(["listId": id])
                .order("position")
            if (showLimit != nil) {
                fetchQuery = fetchQuery.limit(showLimit!)
            }
            let results: [SupabaseShowListEntry]? = try await fetchQuery
                .execute()
                .value
            return results
        } catch {
            dump(error)
            return nil
        }
    }
    
    @MainActor
    func loadList(id: Int, showLimit: Int? = nil) async {
        async let listFetch = fetchList(id: id)
        async let entriesFetch = fetchEntries(id: id, showLimit: showLimit)
        let (list, entries) = await (listFetch, entriesFetch)
        if (list != nil && entries != nil) {
            let listObj = ShowList(list: list!, entries: entries!)
            await setShowList(showList: listObj)
        }
        
    }
}

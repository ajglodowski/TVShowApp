//
//  OwnedListsViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/23/24.
//

import Foundation

struct ListfetchDto: Codable {
    var id: Int
}

class OwnedListsViewModel: ObservableObject {
    
    @Published var lists: [Int]? = nil
    
    @MainActor
    func setLists(lists: [Int]) async {
        self.lists = lists
    }
    
    
    func fetchLists(profileId: String, currentUser: Bool) async -> [Int] {
        do {
            var fetchedLists: [ListfetchDto]
            if (currentUser) {
                fetchedLists = try await supabase
                    .from("showList")
                    .select("id")
                    .match(["creator": profileId])
                    .execute()
                    .value
            } else {
                fetchedLists = try await supabase
                    .from("showList")
                    .select("id")
                    .match(["creator": profileId, "private": false])
                    .execute()
                    .value
            }
            let ids = fetchedLists.map { $0.id }
            dump(ids)
            return ids
        } catch {
            dump(error)
        }
        
        return []
    }
    
    func loadLists(profileId: String, currentUser: Bool) async {
        let lists = await fetchLists(profileId: profileId, currentUser: currentUser)
        await setLists(lists: lists)
    }
    
}

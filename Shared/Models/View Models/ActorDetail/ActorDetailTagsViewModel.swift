//
//  ActorDetailTagsViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/16/24.
//

import Foundation

class ActorDetailTagsViewModel: ObservableObject {
    
    @Published var tagCounts: [Tag: Int]? = nil
    
    @MainActor
    func setTagCounts(tagCounts: [Tag:Int]) {
        self.tagCounts = tagCounts
    }
    
    func fetchAllTagData(showList: [Int]) async -> [Int:[Tag]] {
        await withTaskGroup(of: (Int, [Tag]).self) { taskGroup in
            for key in showList {
                taskGroup.addTask {
                    let tags = await getTagsForShow(showId: key)
                    return (key, tags)
                }
            }
            
            var tagDict = [Int: [Tag]]()
            
            for await (key, tags) in taskGroup {
                tagDict[key] = tags
            }
            
            return tagDict
        }
    }
    
    func fetchTagDataForActor(showList: [Int]) async {
        let tagDataForShows = await fetchAllTagData(showList: showList)
        var tagCounts = [Tag:Int]()
        for (showId, tagArray) in tagDataForShows {
            for tag in tagArray {
                if (tagCounts[tag] == nil) { tagCounts[tag] = 1 }
                else { tagCounts[tag]! += 1 }
            }
        }
        await setTagCounts(tagCounts: tagCounts)
    }
    
}

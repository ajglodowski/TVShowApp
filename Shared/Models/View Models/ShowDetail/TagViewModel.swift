//
//  TagViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import Foundation
class TagViewModel: ObservableObject {
    
    @Published var tags: [Tag]? = nil
    
    @MainActor
    func setTags(tags: [Tag]) {
        self.tags = tags
    }
    
    func loadTags(showId: Int) async {
        let tags = await getTagsForShow(showId: showId)
        await setTags(tags: tags)
    }
    
}

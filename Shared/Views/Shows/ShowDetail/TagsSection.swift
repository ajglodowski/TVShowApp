//
//  TagsSection.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/24/22.
//

import SwiftUI

struct TagsSection: View {
    
    var showId: String
    var activeTags: [Tag]
    
    var otherTags: [Tag] {
        return Tag.allCases.filter { !activeTags.contains($0) }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tags:")
            if (!activeTags.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(activeTags) { tag in
                            Button(action: {
                                removeTagFromShow(showId: showId, tag: tag)
                            }) {
                                Text(tag.rawValue)
                                Image(systemName:"xmark")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            } else {
                Text("None")
            }
            
            Text("Add tags:")
            ForEach(TagCategory.allCases) { category in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(otherTags.filter { $0.category == category} ) { tag in
                            Button(action: {
                                addTagToShow(showId: showId, tag: tag)
                            }) {
                                Text(tag.rawValue)
                                Image(systemName:"plus")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
    }
}

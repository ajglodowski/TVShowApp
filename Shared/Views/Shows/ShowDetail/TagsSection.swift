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
    
    @State var editingTags = false
    var otherTags: [Tag] {
        return Tag.allCases.filter { !activeTags.contains($0) }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tags:")
                Spacer()
                Button(action: {
                    editingTags.toggle()
                }) {
                    if (editingTags) { Text("Stop Editing") }
                    else { Text("Edit Tags") }
                }
                .buttonStyle(.bordered)
            }
            if (!activeTags.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(activeTags) { tag in
                            Button(action: {
                                if (editingTags) { removeTagFromShow(showId: showId, tag: tag) }
                            }) {
                                Text(tag.rawValue)
                                if (editingTags) { Image(systemName:"xmark") }
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                        }
                    }
                }
            } else {
                Text("None")
            }
            
            if (editingTags) {
                Text("Add tags:")
                ForEach(TagCategory.allCases) { category in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(otherTags.filter { $0.category == category} ) { tag in
                                Button(action: {
                                    if (editingTags) { addTagToShow(showId: showId, tag: tag) }
                                }) {
                                    Text(tag.rawValue)
                                    if (editingTags) { Image(systemName:"plus") }
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            TagsSection(showId: SampleShow.id, activeTags: [Tag.Animated])
        }
    }
}

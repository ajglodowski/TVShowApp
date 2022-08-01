//
//  TagsSection.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/24/22.
//

import SwiftUI

struct TagsSection: View {
    
    @Binding var activeTags: [Tag]?
    
    var otherTags: [Tag] {
        if (activeTags != nil) {
            return Tag.allCases.filter { !activeTags!.contains($0) }
        } else {
            return Tag.allCases
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tags:")
            if (activeTags != nil && !activeTags!.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(activeTags!) { tag in
                            Button(action: {
                                if (activeTags == nil) {
                                    activeTags = []
                                }
                                activeTags!.removeAll(where: { $0 == tag})
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
                                if (activeTags == nil) {
                                    activeTags = []
                                }
                                activeTags!.append(tag)
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

//
//  TagsSection.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/24/22.
//

import SwiftUI

struct TagsSection: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @StateObject var tagVm = TagViewModel()
    
    var showId: Int
    
    var activeTags: [Tag] { tagVm.tags ?? [] }
    var allTags: [Tag] { modelData.tags }
    var tagCategories: [TagCategory] { modelData.tagCategories }
    
    @State var editingTags = false
    var otherTags: [Tag] {
        allTags.filter { !activeTags.contains($0) }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tags:")
                Spacer()
                Button(action: {
                    editingTags.toggle()
                }) {
                    if (editingTags) {
                        HStack {
                            Text("Done")
                            Image(systemName:"checkmark")
                        }
                    }
                    else { Text("Edit Tags") }
                }
                .buttonStyle(.bordered)
            }
            if (!activeTags.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(activeTags) { tag in
                            Button(action: {
                                if (editingTags) { 
                                    Task {
                                        let response = await removeTagFromShow(showId:showId, tagId:tag.id)
                                        if (response) {
                                            await tagVm.loadTags(showId: showId)
                                        }
                                    }
                                }
                            }) {
                                Text(tag.name)
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
                ForEach(tagCategories) { category in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(otherTags.filter { $0.category == category} ) { tag in
                                Button(action: {
                                    if (editingTags) {
                                        Task {
                                            let response = await addTagToShow(showId: showId, tagId: tag.id)
                                            if (response) {
                                                await tagVm.loadTags(showId: showId)
                                            }
                                        }
                                    }
                                }) {
                                    Text(tag.name)
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
        .task {
            await tagVm.loadTags(showId: showId)
        }
    }
}

#Preview {
    TagsSection(showId: MockSupabaseShow.id)
        .environmentObject(ModelData())
}

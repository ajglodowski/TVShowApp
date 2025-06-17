//
//  TagsFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct TagsFilter: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    private var allTags: [Tag] { modelData.tags }
    private var tagCategories: [TagCategory] { modelData.tagCategories }
    private var unselectedTags: [Tag] {
        allTags.filter { tag in
            !filters.tags.contains { $0.id == tag.id }
        }
    }
    
    @State private var expandedCategories: Set<Int> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "tag.fill")
                Text("Tags")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            // Selected tags (horizontal scroll)
            if !filters.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters.tags) { tag in
                            Button(action: {
                                filters.tags.removeAll { $0.id == tag.id }
                            }) {
                                HStack(spacing: 4) {
                                    Text(tag.name)
                                    Image(systemName: "xmark")
                                }
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.blue)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            
            // Available tags grouped by category
            if !unselectedTags.isEmpty {
                Text("Add tags:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach(tagCategories) { category in
                    let categoryTags = unselectedTags.filter { $0.category.id == category.id }
                    if !categoryTags.isEmpty {
                        DisclosureGroup(
                            isExpanded: Binding<Bool> (
                                get: {
                                    return expandedCategories.contains(category.id)
                                },
                                set: { isExpanding in
                                    if isExpanding {
                                        expandedCategories.insert(category.id)
                                    } else {
                                        expandedCategories.remove(category.id)
                                    }
                                }
                            )
                        ) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categoryTags) { tag in
                                        Button(action: {
                                            filters.tags.append(tag)
                                        }) {
                                            Text(tag.name)
                                        }
                                        .foregroundStyle(.primary)
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.capsule)
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        } label: {
                            HStack {
                                if let icon = category.icon {
                                    Image(systemName: icon)
                                        .foregroundColor(.primary)
                                        .font(.system(size: 14))
                                }
                                Text(category.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundStyle(.primary)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    @State var filters: ShowFilters = ShowFilters()
    let modelData = ModelData()
    TagsFilter(filters: $filters, modelData: modelData)
}

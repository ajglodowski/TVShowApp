//
//  CurrentUserStatusesFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct CurrentUserStatusesFilter: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    private var allStatuses: [Status] { modelData.statuses }
    private var unselectedStatuses: [Status] {
        allStatuses.filter { status in
            !filters.userStatuses.contains { $0.id == status.id }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Statuses")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.userStatuses) { status in
                        Button(action: {
                            filters.userStatuses.removeAll { $0.id == status.id }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: status.icon)
                                Text(status.name)
                                    .fixedSize()
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                    }
                    
                    ForEach(unselectedStatuses) { status in
                        Button(action: {
                            filters.userStatuses.append(status)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: status.icon)
                                Text(status.name)
                                    .fixedSize()
                            }
                        }
                        .foregroundStyle(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

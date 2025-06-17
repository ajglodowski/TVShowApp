//
//  ServiceFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct ServiceFilter: View {
    @Binding var filters: ShowFilters
    let modelData: ModelData
    
    private var allServices: [SupabaseService] { modelData.services }
    private var unselectedServices: [SupabaseService] {
        allServices.filter { !filters.service.contains($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Text("Service")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.service) { service in
                        Button(action: {
                            filters.service = filters.service.filter { $0 != service }
                        }) {
                            HStack(spacing: 4) {
                                Text(service.name)
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                    }
                    ForEach(unselectedServices) { service in
                        Button(action: {
                            filters.service.append(service)
                        }) {
                            Text(service.name)
                        }
                        .foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(Service(rawValue: service.name)?.color ?? .none)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

#Preview {
    @State var filters = ShowFilters()
    let modelData = ModelData()
    return ServiceFilter(filters: $filters, modelData: modelData)
}

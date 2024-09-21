//
//  ShowSearchFilters.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/26/24.
//

import SwiftUI

struct ShowSearchFilters: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @Binding var filters: ShowFilters
    
    var allServices: [SupabaseService] { modelData.services }
    var unselectedServices: [SupabaseService] {
        allServices.filter { !filters.service.contains($0) }
    }
    
    var extendedAirDates: [AirDate?] {
        var out: [AirDate?] = AirDate.allCases
        out.append(nil)
        return out
    }
    var unselectedAirdates: [AirDate?] {
        extendedAirDates.filter { !filters.airDate.contains($0) }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Service")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack { // Service Filter
                        ForEach(filters.service) { service in
                            Button(action: {
                                filters.service = filters.service.filter { $0 != service }
                            }) {
                                Label(service.name, systemImage: "xmark")
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.blue)
                        }
                        ForEach(unselectedServices) { service in
                            Button(action: {
                                filters.service.append(service)
                            }) {
                                Label(service.name, systemImage: "plus")
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Airdate")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filters.airDate.indices, id: \.self) { index in
                            Button(action: {
                                filters.airDate.remove(at: index)
                            }) {
                                Label(filters.airDate[index]?.rawValue ?? "None", systemImage: "xmark")
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.blue)
                        }
                        ForEach(unselectedAirdates.indices, id:\.self) { index in
                            Button(action: {
                                filters.airDate.append(unselectedAirdates[index])
                            }) {
                                Label(unselectedAirdates[index]?.rawValue ?? "None", systemImage: "plus")
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

#Preview {
    @State var filters = ShowFilters(service: [], length: [], airDate: [])
    return ShowSearchFilters(filters: $filters)
        .environmentObject(ModelData())
}

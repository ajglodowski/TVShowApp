//
//  AirdateFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct AirdateFilter: View {
    @Binding var filters: ShowFilters
    
    private var extendedAirDates: [AirDate?] {
        var out: [AirDate?] = AirDate.allCases
        out.append(nil)
        return out
    }
    
    private var unselectedAirdates: [AirDate?] {
        extendedAirDates.filter { !filters.airDate.contains($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "calendar")
                Text("Airdate")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.airDate.indices, id: \.self) { index in
                        Button(action: {
                            filters.airDate.remove(at: index)
                        }) {
                            HStack(spacing: 4) {
                                Text(filters.airDate[index]?.rawValue ?? "None")
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                    }
                    ForEach(unselectedAirdates.indices, id:\.self) { index in
                        Button(action: {
                            filters.airDate.append(unselectedAirdates[index])
                        }) {
                            Text(unselectedAirdates[index]?.rawValue ?? "None")
                        }
                        .foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

#Preview {
    @State var filters = ShowFilters()
    return AirdateFilter(filters: $filters)
}

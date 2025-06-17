//
//  LengthFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct LengthFilter: View {
    @Binding var filters: ShowFilters
    
    private var unselectedLengths: [ShowLength] {
        ShowLength.allCases.filter { !filters.length.contains($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "clock")
                Text("Length")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.length.indices, id: \.self) { index in
                        Button(action: {
                            filters.length.remove(at: index)
                        }) {
                            HStack(spacing: 4) {
                                Text(filters.length[index].rawValue + "m")
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.blue)
                    }
                    ForEach(unselectedLengths) { length in
                        Button(action: {
                            filters.length.append(length)
                        }) {
                            Text(length.rawValue + "m")
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
    @State var filters: ShowFilters = ShowFilters()
    return LengthFilter(filters: $filters)
}

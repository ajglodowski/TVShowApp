//
//  CurrentUserWatchlistFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct CurrentUserWatchlistFilter: View {
    @Binding var filters: ShowFilters
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Added to My Watchlist")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                Button(action: {
                    filters.addedToWatchlist = filters.addedToWatchlist == true ? nil : true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: filters.addedToWatchlist == true ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("Yes")
                            .fixedSize()
                        if filters.addedToWatchlist == true {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(filters.addedToWatchlist == true ? .green : .gray)
                
                Button(action: {
                    filters.addedToWatchlist = filters.addedToWatchlist == false ? nil : false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: filters.addedToWatchlist == false ? "xmark.circle.fill" : "xmark.circle")
                        Text("No")
                            .fixedSize()
                        if filters.addedToWatchlist == false {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(filters.addedToWatchlist == false ? .red : .gray)
                
                Spacer()
            }
        }
    }
}

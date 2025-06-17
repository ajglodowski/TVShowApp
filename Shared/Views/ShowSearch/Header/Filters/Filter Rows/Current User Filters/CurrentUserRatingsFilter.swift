//
//  CurrentUserRatingsFilter.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/5/25.
//
import SwiftUI

struct CurrentUserRatingsFilter: View {
    @Binding var filters: ShowFilters
    
    private var allRatings: [Rating] { Rating.allCases }
    private var unselectedRatings: [Rating] {
        allRatings.filter { !filters.userRatings.contains($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Ratings")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters.userRatings, id: \.self) { rating in
                        Button(action: {
                            filters.userRatings.removeAll { $0 == rating }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: rating.ratingSymbol + ".fill")
                                    .foregroundColor(rating.color)
                                Text(rating.rawValue)
                                Image(systemName: "xmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(rating.color)
                    }
                    
                    ForEach(unselectedRatings, id: \.self) { rating in
                        Button(action: {
                            filters.userRatings.append(rating)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: rating.ratingSymbol)
                                    .foregroundColor(rating.color)
                                Text(rating.rawValue)
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

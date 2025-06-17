//
//  SortButton.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/9/25.
//
import SwiftUI

struct SortButton: View {
    let currentSort: SortOption?
    let action: (SortOption?) -> Void
    
    private var displayText: String {
        currentSort?.displayName ?? "Alphabetical (A-Z)"
    }
    
    private var displayIcon: String {
        currentSort?.icon ?? "textformat.abc"
    }
    
    private var orderIcon: String? {
        if currentSort == nil { return nil }
        return currentSort?.ascending ?? true ? "arrow.up" : "arrow.down"
    }
    
    var body: some View {
        Menu {
            // Alphabetical Section
            Section("Alphabetical") {
                Button(action: {
                    action(.alphabeticalAsc)
                }) {
                    Label("Alphabetical (A-Z)", systemImage: "textformat.abc")
                }
                
                Button(action: {
                    action(.alphabeticalDesc)
                }) {
                    Label("Alphabetical (Z-A)", systemImage: "textformat.abc")
                }
            }
            
            // Popularity Section
            Section("Popularity") {
                Button(action: {
                    action(.weeklyPopularityDesc)
                }) {
                    Label("Popularity (Weekly)", systemImage: "clock")
                }
                
                Button(action: {
                    action(.monthlyPopularityDesc)
                }) {
                    Label("Popularity (Monthly)", systemImage: "calendar")
                }
                
                Button(action: {
                    action(.yearlyPopularityDesc)
                }) {
                    Label("Popularity (Yearly)", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
            
            // Rating Section
            Section("Rating") {
                Button(action: {
                    action(.userRatingDesc)
                }) {
                    Label("Your Rating (High-Low)", systemImage: "hand.thumbsup.fill")
                }
                
                Button(action: {
                    action(.userRatingAsc)
                }) {
                    Label("Your Rating (Low-High)", systemImage: "hand.thumbsdown.fill")
                }
                
                Button(action: {
                    action(.avgRatingDesc)
                }) {
                    Label("Average Rating (High-Low)", systemImage: "heart.fill")
                }
                
                Button(action: {
                    action(.avgRatingAsc)
                }) {
                    Label("Average Rating (Low-High)", systemImage: "heart")
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: displayIcon)
                if (orderIcon != nil) {
                    Image(systemName: orderIcon)
                }
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
        }
        .buttonStyle(.glass)
        .tint(currentSort != nil ? .blue : .primary)
    }
}

#Preview("Sort Button") {
    VStack(spacing: 20) {
        SortButton(currentSort: nil, action: { _ in })
        SortButton(currentSort: .alphabeticalAsc, action: { _ in })
        SortButton(currentSort: .weeklyPopularityDesc, action: { _ in })
    }
    .padding()
}

//
//  FilterButton.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/9/25.
//
import SwiftUI

struct FilterButton: View {
    let hasActiveFilters: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                if hasActiveFilters {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .buttonStyle(.glass)
        .tint(hasActiveFilters ? .blue : .primary)
    }
}

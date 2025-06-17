//
//  ShowDetailTabViews.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

// MARK: - Tab Content Views
struct ShowInfoTab: View {
    let show: Show
    let backgroundColor: Color
    let showId: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ShowDetailText(show: show)
            Divider()
            TagsSection(showId: showId)
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading,.trailing])
        .foregroundColor(.white)
    }
}

struct ActorsTab: View {
    let show: Show
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Actors")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button("Edit Actors") {
                    // Edit actors action
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
            
            ShowDetailActors(show: show, backgroundColor: backgroundColor)
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading,.trailing])
        .foregroundColor(.white)
    }
}

struct SimilarShowsTab: View {
    let backgroundColor: Color
    let showId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            SimilarShowsSection(showId: showId)
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading,.trailing])
        .foregroundColor(.white)
    }
}

struct YourUpdatesTab: View {
    let show: Show
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Updates")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            UpdateLogSection(show: show)
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading,.trailing])
        .foregroundColor(.white)
    }
}

struct FriendsUpdatesTab: View {
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Friend's Updates")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Friend's updates feature coming soon!")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading,.trailing])
        .foregroundColor(.white)
    }
}

struct StatsTab: View {
    let backgroundColor: Color
    let showId: Int
    
    var body: some View {
        VStack(spacing: 16) {
            ShowRatingsGraph(backgroundColor: backgroundColor, showId: showId)
            ShowStatusGraph(backgroundColor: backgroundColor, showId: showId)
        }
        .padding()
    }
} 
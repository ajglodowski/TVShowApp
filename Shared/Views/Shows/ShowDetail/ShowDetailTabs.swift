//
//  ShowDetailTabs.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

// MARK: - Your Info Section
struct YourInfoSection: View {
    let show: Show
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RatingSection(show: show)
            UpdateStatusButtons(showId: show.id)
            ShowSeasonsRow(backgroundColor: backgroundColor, showId: show.id)
            
            if (show.addedToUserShows) {
                Button(action: {
                    // Remove from shows action
                    Task {
                        // await reloadData()
                    }
                }) {
                    Text("Remove from My Shows")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading,.trailing])
        .foregroundColor(.white)
    }
}

// MARK: - Scrollable Tab Bar with Icons
struct ScrollableTabBar: View {
    @Binding var selectedTab: String
    
    private let tabs = [
        ("show-info", "Show Info", "info.circle"),
        ("actors", "Actors", "person.3"),
        ("similar-shows", "Similar Shows", "tv"),
        ("your-updates", "Your Updates", "list.bullet"),
        ("friends-updates", "Friend's Updates", "person.3.sequence"),
        ("stats", "Stats", "chart.bar")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tabs, id: \.0) { tab in
                    Button(action: {
                        selectedTab = tab.0
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: tab.2)
                                .font(.system(size: 14, weight: .medium))
                            Text(tab.1)
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedTab == tab.0 ? .white : .white.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Tab Content Container
struct TabContentContainer: View {
    let show: Show
    let backgroundColor: Color
    let selectedTab: String
    
    var body: some View {
        Group {
            switch selectedTab {
            case "show-info":
                ShowInfoTab(show: show, backgroundColor: backgroundColor, showId: show.id)
            case "actors":
                ActorsTab(show: show, backgroundColor: backgroundColor)
            case "similar-shows":
                SimilarShowsTab(backgroundColor: backgroundColor, showId: show.id)
            case "your-updates":
                YourUpdatesTab(show: show, backgroundColor: backgroundColor)
            case "friends-updates":
                FriendsUpdatesTab(backgroundColor: backgroundColor)
            case "stats":
                StatsTab(backgroundColor: backgroundColor, showId: show.id)
            default:
                ShowInfoTab(show: show, backgroundColor: backgroundColor, showId: show.id)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
}

#Preview {
    let mockShow = Show(from: MockSupabaseShow)
    TabContentContainer(show: mockShow, backgroundColor: .blue, selectedTab: "show-info")
}

#Preview {
    @State var selectedTab: String = "show-info"
    ScrollableTabBar(selectedTab: $selectedTab)
}

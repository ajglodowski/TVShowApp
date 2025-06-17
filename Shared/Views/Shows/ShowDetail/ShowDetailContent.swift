//
//  ShowDetailContent.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ShowDetailContent: View {
    let show: Show
    let photo: UIImage?
    let backgroundColor: Color
    @Binding var selectedTab: String
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack (alignment: .center, spacing: 0) {
                    // Show Picture and Title
                    ShowDetailImage(photo: photo, showName: show.name, geometry: geometry)
                    
                    // Service and Length Info
                    ShowServiceInfo(show: show)
                    
                    // Your Info Section (always visible)
                    YourInfoSection(show: show, backgroundColor: backgroundColor)
                    
                    // Scrollable Tab Bar at the top
                    ScrollableTabBar(selectedTab: $selectedTab)
                    
                    // Tab Content
                    TabContentContainer(show: show, backgroundColor: backgroundColor, selectedTab: selectedTab)
                        .padding(.top, 8)
                }
            }
            .ignoresSafeArea(edges: .horizontal)
        }
    }
}

struct ShowServiceInfo: View {
    let show: Show
    
    var body: some View {
        HStack {
            Text("\(show.length.rawValue)m")
            Text("•")
            Text(show.service.rawValue ?? "Unknown Service")
        }
        .font(.title2)
        .foregroundColor(.white)
        .padding(.bottom)
    }
}

struct ShowDetailTabView: View {
    let show: Show
    let backgroundColor: Color
    @Binding var selectedTab: String
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ShowInfoTab(show: show, backgroundColor: backgroundColor, showId: show.id)
                .tag("show-info")
            
            ActorsTab(show: show, backgroundColor: backgroundColor)
                .tag("actors")
            
            SimilarShowsTab(backgroundColor: backgroundColor, showId: show.id)
                .tag("similar-shows")
            
            YourUpdatesTab(show: show, backgroundColor: backgroundColor)
                .tag("your-updates")
            
            FriendsUpdatesTab(backgroundColor: backgroundColor)
                .tag("friends-updates")
            
            StatsTab(backgroundColor: backgroundColor, showId: show.id)
                .tag("stats")
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 600)
    }
}

#Preview {
    let mockShow = Show(from: MockSupabaseShow)
    @State var selectedTab: String = "show-info"
    ShowDetailTabView(show: mockShow, backgroundColor: .blue, selectedTab: $selectedTab)
        .environmentObject(ModelData())
}

//#Preview {
//    let mockShow = Show(from: MockSupabaseShow)
//    @State var selectedTab: String = "show-info"
//    ShowDetailContent(show: mockShow, photo: nil, backgroundColor: .blue, selectedTab: $selectedTab)
//        .environmentObject(ModelData())
//}

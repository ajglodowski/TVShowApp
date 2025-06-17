//
//  SimilarShowsSection.swift
//  TV Show App
//
//  Created by AJ Glodowski on [Current Date]
//

import SwiftUI

struct SimilarShowsSection: View {
    let showId: Int
    
    @StateObject private var vm = SimilarShowsViewModel()
    
    var similarShows: [Show] { vm.similarShows ?? [] }
    var isLoading: Bool { vm.isLoading }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Similar Shows")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if isLoading {
                LoadingSimilarShowsSection()
            } else if similarShows.isEmpty {
                EmptySimilarShowsSection()
            } else {
                SimilarShowsScrollRow(shows: similarShows)
            }
        }
        .task {
            await vm.loadSimilarShows(showId: showId)
        }
    }
}

struct SimilarShowsScrollRow: View {
    let shows: [Show]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(shows) { show in
                    NavigationLink(destination: ShowDetail(showId: show.id)) {
                        ShowSquareTile(show: show, titleShown: true)
                    }
                    .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 5)
        }
    }
}

struct LoadingSimilarShowsSection: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 150)
                        .cornerRadius(15)
                        .padding(.horizontal, 5)
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.horizontal, 5)
        }
    }
}

struct EmptySimilarShowsSection: View {
    var body: some View {
        VStack {
            Image(systemName: "tv.slash")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No similar shows found")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        SimilarShowsSection(showId: 1)
    }
} 
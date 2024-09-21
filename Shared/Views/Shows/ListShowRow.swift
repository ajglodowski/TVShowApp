//
//  ShowRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import SkeletonUI

struct ListShowRow: View {
    
    @ObservedObject var vm = ShowTileViewModel()
    
    var show: Show
    
    var seasonsText: String {
        let seasons = show.totalSeasons > 1 ? "Seasons" : "Season"
        let currentSeason = show.addedToUserShows ? "\(show.userSpecificValues!.currentSeason)/" : ""
        return "\(currentSeason)\(show.totalSeasons) \(seasons)"
    }
    
    var body: some View {
        HStack {
            VStack { // Show Image
                Image(uiImage: vm.showImage)
                    .resizable()
                    .skeleton(with: vm.showImage == nil, shape: .rectangle)
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(show.name)
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        Text("\(show.length.rawValue)m")
                            .font(.callout)
                        ServiceBubble(service: show.service)
                        if (show.limitedSeries) {
                            ShowRowBubble(text: "Limited", backgroundColor: Color(.black))
                        }
                        ShowRowBubble(text: seasonsText, backgroundColor: Color(.quaternaryLabel))
                    }
                    .fixedSize()
                }
                .scrollIndicators(.hidden)
            }
            Spacer()
            if (show.addedToUserShows && show.userSpecificValues!.rating != nil) {
                Image(systemName: "\(show.userSpecificValues!.rating!.ratingSymbol).fill")
                    .foregroundColor(show.userSpecificValues!.rating!.color)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .task(id: show.name) {
            await vm.loadImage(showName: show.name)
        }
    }
}

struct ShowRowBubble: View {
    var text: String
    var backgroundColor: Color
    var body: some View {
        Text(text)
            .font(.callout)
            .padding(6)
            .background(Capsule().fill(backgroundColor))
    }
}

#Preview {
    var mockShow = Show(from: MockSupabaseShow)
    mockShow.name = "House of the Dragon"
    return ListShowRow(show: mockShow)
    
}


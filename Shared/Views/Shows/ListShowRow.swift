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
    
    @State private var scrollOffset = 0
    
    var body: some View {
        HStack {
            
            VStack { // Show Image
                Image(uiImage: vm.showImage)
                    .resizable()
                    .skeleton(with: vm.showImage == nil)
                    .shape(type: .rectangle)
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text(show.name)
                    .font(.headline)
                //ScrollView(.horizontal) {
                    HStack {
                        
                        Text("\(show.length.rawValue)m")
                            .font(.callout)
                        ServiceBubble(service: show.service)
                        if (show.limitedSeries) {
                            Text("Limited")
                                .font(.callout)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(Capsule().fill(.black))
                        }
                        /*
                         if (show.status != nil) {
                         Text("\(show.status!.rawValue)")
                         .font(.callout)
                         .padding(6)
                         .background(Capsule().fill(.quaternary))
                         }
                         */
                        if (show.addedToUserShows) {
                            Text("\(show.userSpecificValues!.currentSeason)/\(show.totalSeasons) \(show.totalSeasons > 1 ? "Seasons" : "Season")")
                                .font(.callout)
                                .padding(6)
                                .background(Capsule().fill(.quaternary))
                        } else {
                            Text("\(show.totalSeasons) \(show.totalSeasons > 1 ? "Seasons" : "Season")")
                                .font(.callout)
                                .padding(6)
                                .background(Capsule().fill(.quaternary))
                        }
                    }
                    .fixedSize()
                    .offset(x: CGFloat(scrollOffset))
                    .animation(.linear(duration: 10).repeatForever(autoreverses: true), value: scrollOffset)
                //}
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

#Preview {
    var mockShow = Show(from: MockSupabaseShow)
    mockShow.name = "House of the Dragon"
    return ListShowRow(show: mockShow)
    
}


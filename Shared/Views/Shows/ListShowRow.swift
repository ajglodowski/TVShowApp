//
//  ShowRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ListShowRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @ObservedObject var vm = ShowTileViewModel()
    
    var show: Show
    
    @State private var scrollOffset = 0
    
    var body: some View {
        HStack {
            
            VStack { // Show Image
                if (show.tileImage != nil) {
                    Image(uiImage: show.tileImage!)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                } else {
                    Image(systemName : "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
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
                        if (show.currentSeason != nil) {
                            Text("\(show.currentSeason!)/\(show.totalSeasons) \(show.totalSeasons > 1 ? "Seasons" : "Season")")
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
            if (show.rating != nil) {
                Image(systemName: "\(show.rating!.ratingSymbol).fill")
                    .foregroundColor(show.rating!.color)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .task(id: show.name) {
            vm.loadImage(modelData: modelData, showId: show.id, showName: show.name)
            //vm.loadImage(showName: show.name)
        }
    }
}

struct ListShowRow_Previews: PreviewProvider {

    static var shows = ModelData().shows
    
    //@ObservedObject var showStore = ShowStore()
    static var previews: some View {
        //Grid() {
            ListShowRow(show: shows[0])
        //}
    }
}

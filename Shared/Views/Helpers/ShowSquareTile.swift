//
//  ShowSquareTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI

struct ShowSquareTile: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @StateObject var vm = ShowTileViewModel()
    
    var show: Show
    
    var titleShown: Bool
    
    var ratingShown: Bool?
    var hasRating: Bool { show.rating != nil }
    
    var aboveExtraText: [String]? // Text below the tile
    var aboveFontType: Font?
    
    var belowExtraText: [String]? // Text below the tile
    var belowFontType: Font?
    
    private var backgroundColor: Color {
        if (show.tileImage != nil) { return Color(vm.showImage?.averageColor ?? .black) }
        else { return Color.black }
    }
    
    var body: some View {
        
        VStack {
            
            if (aboveExtraText != nil) {
                VStack {
                    ForEach(aboveExtraText!, id: \.self) { line in
                        if (aboveFontType == nil) {
                            Text(line)
                        } else {
                            Text(line)
                                .font(aboveFontType)
                        }
                    }
                }
            }
            
            if (show.tileImage != nil) {
                Image(uiImage: show.tileImage!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .if(show.status == Status.NewSeason) {
                        $0.overlay(TileBanner(text: "New\nSeason"),alignment: .bottomLeading)
                    }
                    .shadow(radius: 5)
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                LoadingView()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
                
            if (titleShown) {
                if (!show.partiallyLoaded) {
                    HStack {
                        Text(show.name)
                            .font(.headline)
                            .scaledToFit()
                    }
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        Text(show.length.rawValue + "m")
                            .font(.subheadline)
                        Text(show.service.rawValue)
                            .font(.subheadline)
                            .scaledToFit()
                        if (ratingShown != nil && ratingShown! && hasRating) {
                            Image(systemName: "\(show.rating!.ratingSymbol).fill")
                                .foregroundColor(show.rating!.color)
                        }
                    }
                } else {
                    LoadingView()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
            }
            
            if (belowExtraText != nil) {
                VStack {
                    ForEach(belowExtraText!, id:  \.self) { belowLine in
                        if (belowFontType == nil) {
                            Text(belowLine)
                        } else {
                            Text(belowLine)
                                .font(belowFontType)
                        }
                    }
                }
            }
            
        }
        .frame(width: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .foregroundColor(.white)
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 5)
        
        .task(id: show.name){
            vm.loadImage(modelData: modelData, showId: show.id, showName: show.name)
        }
        
    }
}

struct ShowSquareTile_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        VStack {
            HStack {
                ShowSquareTile(show: shows[4], titleShown: true)
                ShowSquareTile(show: shows[4], titleShown: true, belowExtraText: ["Below"])
            }
            HStack {
                ShowSquareTile(show: shows[4], titleShown: true, aboveExtraText: ["Above"])
                ShowSquareTile(show: shows[4], titleShown: true, aboveExtraText: ["Above"], aboveFontType: .headline, belowExtraText: ["Below"])
            }
            HStack {
                ShowSquareTile(show: shows[4], titleShown: true)
            }
        }
    }
}

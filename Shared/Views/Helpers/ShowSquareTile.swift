//
//  ShowSquareTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI
import SkeletonUI

struct ShowSquareTile: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @StateObject var vm = ShowTileViewModel()
    
    var show: Show
    
    var titleShown: Bool
    
    var ratingShown: Bool?
    var hasRating: Bool { show.addedToUserShows && show.userSpecificValues!.rating != nil }
    
    var aboveExtraText: [String]? // Text below the tile
    var aboveFontType: Font?
    
    var belowExtraText: [String]? // Text below the tile
    var belowFontType: Font?
    
    private var backgroundColor: Color {
        if (vm.showImage != nil) { return Color(vm.showImage?.averageColor ?? .black) }
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
            
            Image(uiImage: vm.showImage)
                .resizable()
                .skeleton(with: vm.showImage == nil)
                .shape(type: .rectangle)
                .scaledToFit()
                .cornerRadius(15)
                .if(show.addedToUserShows && show.userSpecificValues!.status.id == NewSeasonStatusId) {
                    $0.overlay(TileBanner(text: "New\nSeason"),alignment: .bottomLeading)
                }
                .shadow(radius: 5)
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            if (titleShown) {
                HStack {
                    Text(show.name)
                        //.skeleton(with: show.partiallyLoaded)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    Text(show.length.rawValue + "m")
                        //.skeleton(with: show.partiallyLoaded)
                        .font(.subheadline)
                    Text(show.service.rawValue)
                        //.skeleton(with: show.partiallyLoaded)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                    if (hasRating && ratingShown != nil && ratingShown!) {
                        Image(systemName: "\(show.userSpecificValues!.rating!.ratingSymbol).fill")
                            .foregroundColor(show.userSpecificValues!.rating!.color)
                    }
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
            await vm.loadImage(showName: show.name)
        }
        
    }
}
/*
#Preview {
    let modelData = ModelData()
    let displayed = modelData.showDict[100]!
    return ShowSquareTile(show: displayed, titleShown: true)
        .environmentObject(modelData)
}
 */

/*
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
*/

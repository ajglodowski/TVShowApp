//
//  ShowSquareTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI

struct ShowSquareTile: View {
    
    var show: Show
    
    //var scrollType: Int? // 0 for generic, 1 for airdates
    
    var aboveExtraText: [String]? // Text below the tile
    var aboveFontType: Font?
    
    var belowExtraText: [String]? // Text below the tile
    var belowFontType: Font?
    
    var body: some View {
        
        VStack {
            
            /*
            if (scrollType == 1) {
                Text(show.airdate.rawValue)
                    .font(.headline)
                    .scaledToFit()
                    .multilineTextAlignment(.center)
            }
             */
            
            if (aboveExtraText != nil) {
                VStack {
                    ForEach(0..<aboveExtraText!.count) { ind in
                        if (aboveFontType == nil) {
                            Text(aboveExtraText![ind])
                        } else {
                            Text(aboveExtraText![ind])
                                .font(aboveFontType)
                        }
                    }
                }
            }
            
            Image(show.name)
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
                .if(show.status == Status.NewSeason) {
                    $0.overlay(TileBanner(text: "New\nSeason"),alignment: .bottomLeading)
                }
                //.frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            
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
            }
            
            if (belowExtraText != nil) {
                VStack {
                    ForEach(0..<belowExtraText!.count) { ind in
                        if (belowFontType == nil) {
                            Text(belowExtraText![ind])
                        } else {
                            Text(belowExtraText![ind])
                                .font(belowFontType)
                        }
                    }
                }
            }
            
        }
        .frame(width: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct ShowSquareTile_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        VStack {
            HStack {
                ShowSquareTile(show: shows[4])
                ShowSquareTile(show: shows[4], belowExtraText: ["Below"])
            }
            HStack {
                ShowSquareTile(show: shows[4], aboveExtraText: ["Above"])
                ShowSquareTile(show: shows[4], aboveExtraText: ["Above"], aboveFontType: .headline, belowExtraText: ["Below"])
            }
            HStack {
                ShowSquareTile(show: shows[4])
            }
        }
    }
}

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
    
    var body: some View {
        
        VStack {
        
            Image(show.name)
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
                .if(show.status == "New Season") {
                    $0.overlay(TileBanner(text: "New Season"),alignment: .bottomLeading)
                }
                
            
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
            
        }
        .frame(width: 150, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct ShowSquareTile_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ShowSquareTile(show: shows[30])
    }
}

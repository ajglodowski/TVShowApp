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
            
            HStack {
            
                Text(show.name)
                    .font(.headline)
                    .scaledToFit()
                    
                Text(show.service.rawValue)
                    .font(.subheadline)
                    .scaledToFit()
            }
            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            
            HStack {
                Text("Episode Length: " + show.length.rawValue + " minutes")
                    .font(.subheadline)
            }
            
        }
        .frame(width: 200, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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

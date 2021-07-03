//
//  ShowTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/2/21.
//

import SwiftUI

struct ShowTile: View {
    
    var show: Show
    
    var body: some View {
        
        VStack {
        
            Image(show.name)
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                //.shadow(radius: 5)

            Text(show.name)
                .font(.subheadline)
        }
        .frame(width: 175, height: 175, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        //.shadow(radius: 5)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct ShowTile_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ShowTile(show: shows[30])
    }
}

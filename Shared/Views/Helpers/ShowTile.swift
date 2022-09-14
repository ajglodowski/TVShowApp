//
//  ShowTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/2/21.
//

import SwiftUI

struct ShowTile: View {
    
    @StateObject var vm = ShowTileViewModel()
    
    //var show: Show
    var showName: String
    
    var body: some View {
        
        VStack {
        
            /*
            Image(showName)
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                //.shadow(radius: 5)
             */
            if (vm.showImage != nil) {
                Image(uiImage: vm.showImage!)
                    .resizable()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .scaledToFit()
            } else {
                Image(systemName : "ellipsis")
                    .resizable()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .scaledToFit()
            }
            

            Text(showName)
                .font(.subheadline)
        }
        .frame(width: 175, height: 175, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .task {
            vm.loadImage(showName: showName)
        }
    }
}

struct ShowTile_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ShowTile(showName: shows[30].name)
    }
}

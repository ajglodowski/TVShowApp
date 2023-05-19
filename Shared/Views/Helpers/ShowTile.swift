//
//  ShowTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/2/21.
//

import SwiftUI

struct ShowTile: View {
    
    @StateObject var vm = ShowTileViewModel()
    var showName: String
    
    var body: some View {
        VStack {
            VStack(alignment:.center) {
                if (vm.showImage != nil) {
                    Image(uiImage: vm.showImage!)
                        .resizable()
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .scaledToFit()
                } else {
                    LoadingView()
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .scaledToFit()
                }
            }
            .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(showName)
                .font(.subheadline)
        }
        .task(id: showName) {
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

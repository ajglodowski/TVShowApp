//
//  ShowTile.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/2/21.
//

import SwiftUI
import SkeletonUI

struct ShowTile: View {
    
    @StateObject var vm = ShowTileViewModel()
    var show: Show
    
    var body: some View {
        VStack {
            VStack(alignment:.center) {
                Image(uiImage: vm.showImage)
                    .resizable()
                    .skeleton(with: vm.showImage == nil)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .scaledToFit()
            }
            .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(show.name)
                .font(.subheadline)
        }
        .task(id: show.id) {
            if let url = show.pictureUrl {
                await vm.loadImage(pictureUrl: url)
            }
        }
    }
}

struct ShowTile_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ShowTile(show: shows[30])
    }
}

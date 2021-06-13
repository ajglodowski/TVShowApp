//
//  ShowRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ListShowRow: View {
    
    var show: Show
    
    var body: some View {
        HStack {
            Text(show.name)
            Spacer()
            
            let index = showIndex(show: show)
            
            if (ModelData().shows[index].watched) {
                Image(systemName: "eye.fill")
            } else {
                Image(systemName: "calendar.circle")
            }
            
            Divider()
            
            if show.running {
                Image(systemName: "checkmark.circle")
            } else {
                Image(systemName: "x.circle")
            }
        }
        .padding()
    }
}

struct ListShowRow_Previews: PreviewProvider {

    static var shows = ModelData().shows
    
    //@ObservedObject var showStore = ShowStore()
    static var previews: some View {
        ListShowRow(show: shows[0])
    }
}

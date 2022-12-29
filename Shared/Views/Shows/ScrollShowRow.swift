//
//  ScrollShowRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/2/21.
//

import SwiftUI

struct ScrollShowRow: View {
    
    var items: [Show]
    var scrollName: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            Text(scrollName)
                .font(.title)
                .padding(.horizontal, 2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(items) { show in
                        NavigationLink(destination: ShowDetail(showId: show.id, show: show)) {
                            ShowTile(showName: show.name)
                        }
                        .accentColor(.primary)
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
}

struct ScrollShowRow_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ScrollShowRow(items: shows, scrollName: "Test")
    }
}

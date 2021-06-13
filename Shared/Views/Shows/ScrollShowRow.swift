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
                .font(.headline)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ShowTile(show: show)
                        }
                    }
                }
            }
            //.frame(height: 185)
        
        }
    }
}

struct ScrollShowRow_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ScrollShowRow(items: shows, scrollName: "Test")
    }
}

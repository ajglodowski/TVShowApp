//
//  SquareTileScrollRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI

struct SquareTileScrollRow: View {
    
    var items: [Show]
    var scrollName: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            Text(scrollName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ShowSquareTile(show: show)
                        }
                    }
                }
            }
            //.frame(height: 185)
        
        }
    }
}

struct SquareTileScrollRow_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        SquareTileScrollRow(items: shows, scrollName: "Test")
    }
}

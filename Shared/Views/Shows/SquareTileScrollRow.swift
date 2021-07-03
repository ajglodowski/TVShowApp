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
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { show in
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ShowSquareTile(show: show)
                        }
                        .foregroundColor(.primary)
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
        SquareTileScrollRow(items: shows)
    }
}

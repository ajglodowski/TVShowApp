//
//  ShowRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ListShowRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var show: Show
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(show.name)
                    .font(.headline)
                HStack {
                    Text("\(show.length.rawValue)m")
                        .font(.callout)
                    Text(show.service.rawValue)
                        .padding(6)
                        .font(.callout)
                        .foregroundColor(.white)
                        .background(Capsule().fill(show.service.color))
                    if (show.limitedSeries) {
                        Text("Limited")
                            .padding(6)
                            .font(.callout)
                            .foregroundColor(.white)
                            .background(Capsule().fill(.black))
                    }
                }
            }
            Spacer()
            if (show.rating != nil) {
                Image(systemName: "\(show.rating!.ratingSymbol).fill")
                    .foregroundColor(show.rating!.color)
            }
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
    }
}

struct ListShowRow_Previews: PreviewProvider {

    static var shows = ModelData().shows
    
    //@ObservedObject var showStore = ShowStore()
    static var previews: some View {
        //Grid() {
            ListShowRow(show: shows[0])
        //}
    }
}

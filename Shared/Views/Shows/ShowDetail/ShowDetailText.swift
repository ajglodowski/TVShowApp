//
//  ShowDetailText.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct ShowDetailText: View {
    
    private static var formatter: DateFormatter = {
        let dF = DateFormatter()
        dF.dateFormat = "'MM'/'dd'/'yyyy'"
        dF.dateStyle = .long
        return dF
    }()
    
    var show: Show
    
    var body: some View {
        HStack {
            Text("Show Length: " + show.length.rawValue + " minutes")
                .font(.subheadline)
            Spacer()
            Text(show.service.rawValue)
                .font(.subheadline)
        }
        HStack {
            if (show.status != nil) {
                Text("Status: " + show.status!.rawValue)
                    .font(.subheadline)
            } else {
                
            }
            Spacer()
            if (show.limitedSeries) {
                Text("Limited Series")
                    .font(.subheadline)
                    .bold()
            }
        }
        
        if (show.status != nil && show.currentlyAiring && show.status == Status.CurrentlyAiring) {
            Text("Airdate: " + show.airdate!.rawValue)
                .font(.subheadline)
        }
         
        if (show.releaseDate != nil) {
            Text("Release Date: " + ShowDetailText.formatter.string(from: show.releaseDate!))
        }
        
        Divider()
        
    }
}

struct ShowDetailText_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        ShowDetailText(show: modelData.shows[0])
            .environmentObject(modelData)
    }
}

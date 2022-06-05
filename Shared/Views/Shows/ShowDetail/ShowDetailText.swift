//
//  ShowDetailText.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct ShowDetailText: View {
    
    var show: Show
    
    var body: some View {
        HStack {
            Text("Show Length: " + show.length.rawValue + " minutes")
                .font(.subheadline)
            Spacer()
            Text(show.service.rawValue)
                .font(.subheadline)
        }
        Text("Status: " + show.status.rawValue)
            .font(.subheadline)
        
        if (show.status == Status.CurrentlyAiring) {
            Text("Airdate: " + show.airdate.rawValue)
                .font(.subheadline)
        }
        
        
        Text("Real test")
        //print(show.releaseDate)
        
         /*
         if (show.releaseDate != nil) {
             
             let dF = DateFormatter()
             dF.dateFormat = "'MM'/'dd'/'yyyy'"
             dF.dateStyle = .long
             Text("Release Date: " + DateFormatter().string(from: show.releaseDate))
             
             Text("Test")
         }
          */
        
        Divider()
        Text("About Show")
    }
}

struct ShowDetailText_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        ShowDetailText(show: modelData.shows[0])
            .environmentObject(modelData)
    }
}

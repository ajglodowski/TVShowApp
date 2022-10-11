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
        //NavigationLink(destination: ShowDetail(show: show)) {
            //GridRow {
            HStack {
                Text(show.name)
                Spacer()
                Text(show.service.rawValue)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(getServiceColor(service: show.service))
                    .cornerRadius(5.0)
                if (show.limitedSeries) {
                    Text("Limited")
                        .padding(5)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(5.0)
                }
                Spacer()
                /*
                if show.running {
                    Image(systemName: "checkmark.circle")
                } else {
                    Image(systemName: "x.circle")
                }
                 */
                if (show.rating != nil) {
                    Image(systemName: "\(show.rating!.ratingSymbol).fill")
                        .foregroundColor(show.rating!.color)
                }
            }
        //}
        /*
         //When IOS updates
         
         .swipeActions(edge: .leading) {
             Button(role: .destructive){
                 withAnimation {
                     modelData.shows.removeAll { show.id == $0.id }
                 }
             } label: {
                 Label("Delete", systemImage: "trash")
             }
         }
         */
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

//
//  ListActorRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI

struct ListActorRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var actorName: String
    
    var body: some View {
        HStack {
            Text(actorName)
            Spacer()
        }
        .padding()
        .overlay (
            Capsule(style: .continuous)
                .stroke(Color.white, lineWidth: 2.0)
        )
        
        //.padding()
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

struct ListActorRow_Previews: PreviewProvider {
    
    static var actors = ModelData().actors
    
    //@ObservedObject var showStore = ShowStore()
    static var previews: some View {
        ListActorRow(actorName: "Test Actor")
    }
}

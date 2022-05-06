//
//  ActorDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI

struct ActorDetail: View {
    
    var actor : Actor
    
    var showList : [Show] {
        actor.shows
    }
    
    var body: some View {
        VStack {
            Text(actor.name)
                .font(.title)
        
            
            ForEach(showList) { show in
                //Text(show.name)
                
                NavigationLink(destination: ShowDetail(show: show)) {
                    ListShowRow(show: show)
                }
                
                
            }
        }
    }
}

struct ActorDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ActorDetail(actor: modelData.actors[0])
                .environmentObject(modelData)
        }
    }
}

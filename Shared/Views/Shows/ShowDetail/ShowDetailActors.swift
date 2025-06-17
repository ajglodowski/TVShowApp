//
//  ShowDetailActors.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct ShowDetailActors: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var actorsVm = ShowDetailActorsViewModel()
    
    var show: Show
    var backgroundColor: Color
    
    var actors: [Actor]? { actorsVm.actors }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let actors = actors, !actors.isEmpty {
                ForEach(actors) { actor in
                    NavigationLink(destination: ActorDetail(actorId: actor.id)) {
                        ListActorRow(actorName: actor.name)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                Text("No actors found")
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
                    .padding(.vertical, 20)
            }
            
            // Simple add button at the bottom
            Button(action: {
                Task {
                    let new = Actor(id: -1)
                    let success = await insertActor(actor: new, showId: show.id)
                    if (success) {
                        await actorsVm.fetchActors(showId: show.id)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Actor")
                }
                .foregroundColor(.white.opacity(0.8))
                .padding(.vertical, 8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .task {
            await actorsVm.fetchActors(showId: show.id)
        }
    }
}
/*
struct ShowDetailActors_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        Group {
            ShowDetailActors(show: modelData.shows[0], backgroundColor: Color.black)
        }
    }
}
*/

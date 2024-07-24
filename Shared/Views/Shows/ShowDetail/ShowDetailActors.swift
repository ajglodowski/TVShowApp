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
        
        VStack {
            VStack(alignment: .leading){
                HStack {
                    Text("Actors")
                        .font(.title)
                    Spacer()
                    Button(action: {
                        Task {
                            await actorsVm.fetchActors(showId: show.id)
                        }
                    }) {
                        Text("Refresh Actors")
                    }
                    .buttonStyle(.bordered)
                }
                if (actors != nil) {
                    ForEach(actors!) { actor in
                        NavigationLink(destination: ActorDetail(actorId: actor.id)) {
                            ListActorRow(actorName: actor.name)
                                .background(backgroundColor.blendMode(.softLight))
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
            }
            Divider()
            // Add a new actor
            Button(action: {
                Task {
                    let new = Actor(id: -1)
                    let success = await insertActor(actor: new, showId: show.id)
                    if (success) {
                        await actorsVm.fetchActors(showId: show.id)
                    }
                }
            }, label: {
                Text("Add a new Actor")
                //.font(.title)
            })
            .buttonStyle(.bordered)
        }
        .task {
            await actorsVm.fetchActors(showId: show.id)
        }
        .padding()
        // Darker, possible use in future
        //.background(Color.secondary)
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
        .foregroundColor(.white)
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

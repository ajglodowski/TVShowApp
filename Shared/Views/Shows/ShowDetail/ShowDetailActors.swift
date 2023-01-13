//
//  ShowDetailActors.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct ShowDetailActors: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var show: Show
    var backgroundColor: Color
    
    var body: some View {
        
        // Old Actor Section
        /*
        VStack(alignment: .leading){
            Text("Actors")
                .font(.title)
            ForEach(actorList) { indActor in
                NavigationLink(destination: ActorDetail(actor: indActor)) {
                    ListActorRow(actor: indActor)
                }
            }
            Divider()
            // Add a new actor
            Button(action: {
                var new = Actor()
                new.shows.append(show)
                //newShow = new
                modelData.actors.append(new)
                //ActorDetail(actor: new)
            }, label: {
                Text("Add a new Actor")
                    //.font(.title)
            })
            .buttonStyle(.bordered)
            
            //.onDelete(perform: removeRows)
            //.background(backgroundColor.blendMode(.softLight))
            
        }
        .padding()
        // Darker, possible use in future
        //.background(Color.secondary)
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
        .foregroundColor(.white)
         */
        
        VStack {
            if (show.actors != nil) {
                VStack(alignment: .leading){
                    Text("Actors")
                        .font(.title)
                    ForEach(show.actors!.sorted(by: >), id:\.key) { actorId, actorName in
                        if (modelData.actorDict[actorId] != nil) {
                            NavigationLink(destination: ActorDetail(actor: modelData.actorDict[actorId]!)) {
                                ListActorRow(actorName: actorName)
                                    .background(backgroundColor.blendMode(.softLight))
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                        }
                    }
                }
            }
            Divider()
            // Add a new actor
            Button(action: {
                var new = Actor(id: "1")
                let newActId = addActorToActors(act: new)
                new.id = newActId
                addActorToShow(act: new, showId: show.id)
            }, label: {
                Text("Add a new Actor")
                //.font(.title)
            })
            .buttonStyle(.bordered)
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

struct ShowDetailActors_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        Group {
            ShowDetailActors(show: modelData.shows[0], backgroundColor: Color.black)
        }
    }
}

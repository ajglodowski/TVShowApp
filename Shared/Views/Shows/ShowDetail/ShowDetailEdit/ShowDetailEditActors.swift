//
//  ShowDetailEditActors.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct ShowDetailEditActors: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @Binding var show : Show
    //let showIndex: Int
    
    @State private var searchText = ""
    var searchActors: [Actor] {
        modelData.actors.filter { act in
            act.name.contains(searchText)
        }
    }
    
    var body: some View {
        // Current Actors
        Section(header: Text("Actors (Changes are live):")) {
            if (show.actors != nil) {
                ForEach(show.actors!.sorted(by: >), id:\.key) { actorId, actorName in
                    HStack {
                        Text(actorName)
                        Spacer()
                        Spacer()
                        Button(action: {
                            // Remove actor from show
                            show.actors![actorId] = nil
                            removeActorFromShow(actorId: actorId, showId: show.id)
                        }, label: {
                            Text("Remove from Show")
                            //.font(.title)
                        })
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            } else {
                Text("No Actors")
            }
        }
        
        // Add an existing actor
        Section(header: Text("Add an existing actor")) {
            HStack { // Search Bar
                Image(systemName: "magnifyingglass")
                TextField("Search for an actor here", text: $searchText)
                    .disableAutocorrection(true)
                if (!searchText.isEmpty) {
                    Button(action: {searchText = ""}, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
            //.padding()
            //.background(Color(.systemGray5))
            //.cornerRadius(20)
            
            ForEach(searchActors) { act in
                Button(action: {
                    show.actors![act.id] = act.name
                    addActorToShow(act: act, showId: show.id, showName: show.name)
                }, label: {
                    Text(act.name)
                })
            }
        }
        
        
        // Add a new actor
        Section(header: Text("Add a new actor")) {
            Button(action: {
                var new = Actor(id: "1")
                new.shows[show.id] = show.name
                let newActId = addActorToActors(act: new)
                new.id = newActId
                addActorToShow(act: new, showId: show.id, showName: show.name)
            }, label: {
                Text("Add a new Actor")
                    //.font(.title)
            })
            .buttonStyle(.bordered)
            //ActorEditList(show: modelData.shows[showIndex])
        }
    }

}
/*
 struct ShowDetailEditActors_Previews: PreviewProvider {
 static let modelData = ModelData()
 static var previews: some View {
 //ShowDetailEditActors(show:modelData.shows[0], showIndex: 0)
 ShowDetailEditActors()
 .environmentObject(modelData)
 }
 }
 */

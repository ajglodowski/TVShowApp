//
//  ShowDetailEditActors.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct ShowDetailEditActors: View {
    
    var body: some View {
        Text("TODO")
    }
    
    /*
    @EnvironmentObject var modelData : ModelData
    
    var show : Show
    let showIndex: Int
    
    
    var actorArr : [Actor] {
        getActors(showIn: show, actors: modelData.actors)
    }
     
    
    @State private var searchText = ""
    var searchActors: [Actor] {
        modelData.actors.filter { act in
            act.name.contains(searchText)
        }
    }
    
    var body: some View {
        // Current Actors
        Section(header: Text("Actors:")) {
            ForEach(actorArr) { act in
                HStack {
                    Text(act.name)
                    Spacer()
                    Spacer()
                    Button(action: {
                        modelData.actors[actorIndex(actor: act)].shows = modelData.actors[actorIndex(actor: act)].shows.filter { $0 != show}
                    }, label: {
                        Text("Remove from Show")
                            //.font(.title)
                    })
                    .buttonStyle(.bordered)
                }
                .padding()
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
                    modelData.actors[actorIndex(actor: act)].addShow(toAdd: show)
                }, label: {
                    Text(act.name)
                })
            }
        }
        
        
        // Add a new actor
        Section(header: Text("Add a new actor")) {
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
            //ActorEditList(show: modelData.shows[showIndex])
        }
    }
     */
}

struct ShowDetailEditActors_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        //ShowDetailEditActors(show:modelData.shows[0], showIndex: 0)
        ShowDetailEditActors()
            .environmentObject(modelData)
    }
}

//
//  ActorDetailEdit.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/10/22.
//

import SwiftUI

struct ActorDetailEdit: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @Binding var isPresented: Bool
    
    @Binding var actor : Actor
    
    //let actorIndex: Int
    /*
    var actorIndex: Int {
        modelData.actors.firstIndex(where: { $0.id == actor.id }) ?? (modelData.actors.firstIndex(where: { $0.name == actor.name }) ?? -1)
    }
     */
    
    @State private var searchText = ""
    var searchShows: [Show] {
        modelData.shows.filter { show in
            show.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var showNames: [String] {
        var output = [String]()
        for (_, showName) in actor.shows {
            output.append(showName)
        }
        return output
    }
    
    var showIds: [String] {
        var output = [String]()
        for (showId, _) in actor.shows {
            output.append(showId)
        }
        return output
    }
    
    var body: some View {
        List {
            
            Section(header: Text("Actor Name:")) {
                HStack {
                    TextField("Actor Name", text: $actor.name)
                        .disableAutocorrection(true)
                        .font(.title)
                    if (!actor.name.isEmpty) {
                        Button(action: { actor.name = "" }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
            }
            //.padding()
            
            // Current Shows
            Section(header: Text("Current Shows:")) {
                ForEach(actor.shows.sorted(by: >), id:\.key) { showId, showName in
                    HStack {
                        Text(showName)
                        Spacer()
                        //Text(show.id)
                        Spacer()
                        Button(action: {
                            removeActorFromShow(actorId: actor.id, showId: showId)
                        }, label: {
                            Text("Remove show")
                                //.font(.title)
                        })
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            
            // Add show to actor
            Section(header: Text("Add an existing show:")) {
                HStack { // Search Bar
                    Image(systemName: "magnifyingglass")
                    TextField("Search for show here", text: $searchText)
                        .disableAutocorrection(true)
                    if (!searchText.isEmpty) {
                        Button(action: {searchText = ""}, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(20)
                
                ForEach(searchShows) { show in
                    Button(action: {
                        addActorToShow(act: actor, showId: show.id)
                    }, label: {
                        Text(show.name)
                    })
                }
                
            }
            
            
            
            // ID
            Section(header: Text("Internal ID:")) {
                //TextField("ID", value: $modelData.actors[actorIndex].id, formatter: NumberFormatter())
                    //.keyboardType(.numberPad)
                Text("ID: "+actor.id)
            }
        }
    }
}

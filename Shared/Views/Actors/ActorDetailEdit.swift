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
    
    var actor : Actor
    
    let actorIndex: Int
    /*
    var actorIndex: Int {
        modelData.actors.firstIndex(where: { $0.id == actor.id }) ?? (modelData.actors.firstIndex(where: { $0.name == actor.name }) ?? -1)
    }
     */
    
    @State private var searchText = ""
    var searchShows: [Show] {
        modelData.shows.filter { show in
            show.name.contains(searchText)
        }
    }
    
    var showArr : [Show] {
        modelData.actors[actorIndex].shows
    }
    
    var body: some View {
        List {
            
            Section(header: Text("Actor Name:")) {
                HStack {
                    TextField("Actor Name", text: $modelData.actors[actorIndex].name)
                        .disableAutocorrection(true)
                        .font(.title)
                    if (!modelData.actors[actorIndex].name.isEmpty) {
                        Button(action: {modelData.actors[actorIndex].name = ""}, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
            }
            //.padding()
            
            // Current Shows
            Section(header: Text("Current Shows:")) {
                ForEach(showArr) { show in
                    HStack {
                        Text(show.name)
                        Spacer()
                        //Text(show.id)
                        Spacer()
                        Button(action: {
                            modelData.actors[actorIndex].shows = modelData.actors[actorIndex].shows.filter { !$0.equals(input: show)}
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
                        modelData.actors[actorIndex].shows.append(show)
                    }, label: {
                        Text(show.name)
                    })
                }
                
            }
            
            
            
            // ID
            Section(header: Text("Internal ID:")) {
                //TextField("ID", value: $modelData.actors[actorIndex].id, formatter: NumberFormatter())
                    //.keyboardType(.numberPad)
                Text("ID: "+modelData.actors[actorIndex].id)
            }
        }
    }
}

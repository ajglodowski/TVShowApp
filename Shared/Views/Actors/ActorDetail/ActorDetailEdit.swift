//
//  ActorDetailEdit.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/10/22.
//

import SwiftUI

struct ActorDetailEdit: View {
    
    @StateObject var showSearchVm = ShowSearchViewModel()
    @StateObject var vm = ActorDetailViewModel()
    
    var currentShows: [Show]? { vm.shows }

    @Binding var isPresented: Bool
    
    @Binding var actor : Actor
    
    @State var searchText: String = ""
    var searchResults: [Show]? { showSearchVm.searchResults }
    var searchShows: [Show]? {
        if (currentShows == nil || searchResults == nil) { return nil }
        return searchResults!.filter { !currentShows!.contains($0) }
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
                if (currentShows == nil) { Text("Loading Shows") }
                else {
                    ForEach(currentShows!) { show in
                        HStack {
                            Text(show.name)
                            Spacer()
                            Button(action: {
                                Task {
                                    let success =  await removeActorFromShow(actorId: actor.id, showId: show.id)
                                    if (success) {
                                        await vm.fetchAllActorData(actorId: actor.id)
                                    }
                                }
                            }, label: {
                                Text("Remove show")
                            })
                            .buttonStyle(.bordered)
                        }
                        .padding()
                    }
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
                
                if (searchShows == nil) { Text("Loading Search Results") }
                else {
                    ForEach(searchShows!) { show in
                        Button(action: {
                            Task {
                                let success = await addActorToShow(actorId: actor.id, showId: show.id)
                                if (success) {
                                    await vm.fetchAllActorData(actorId: actor.id)
                                }
                            }
                        }, label: {
                            Text(show.name)
                        })
                    }
                }
            }
            .task(id: searchText) {
                await showSearchVm.findShows(searchText: searchText)
            }
            
            // ID
            Section(header: Text("Internal ID:")) {
                Text("ID: \(actor.id)")
            }
        }
        .task {
            await vm.fetchAllActorData(actorId: actor.id)
        }
    }
}

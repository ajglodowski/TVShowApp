//
//  ActorReferenceGame.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/25/22.
//

import SwiftUI

struct ActorReferenceGame: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @State var actorList = [Actor]()
    @State var showList = [Show]()
    @State var destinationActor: Actor? = nil
    @State var won = false
    
    @State private var startSearchText = ""
    var startSearchActors: [Actor] {
        modelData.actors.filter { act in
            act.name.contains(startSearchText)
        }
    }
    
    @State private var endSearchText = ""
    var endSearchActors: [Actor] {
        modelData.actors.filter { act in
            act.name.contains(endSearchText)
        }
    }
    
    func addActor(act: Actor) {
        self.actorList.append(act)
        if (act == destinationActor) {
            self.won = true
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Connect the actors by shows")
                if (actorList.isEmpty || destinationActor == nil) {
                    VStack {
                        if (actorList.isEmpty) {
                            Text("Choose a starting actor")
                            HStack { // Search Bar
                                Image(systemName: "magnifyingglass")
                                TextField("Search for an actor here", text: $startSearchText)
                                    .disableAutocorrection(true)
                                if (!startSearchText.isEmpty) {
                                    Button(action: {startSearchText = ""}, label: {
                                        Image(systemName: "xmark")
                                    })
                                }
                            }
                            ForEach(startSearchActors) { act in
                                Button(action: {
                                    actorList.append(act)
                                }, label: {
                                    Text(act.name)
                                })
                            }
                        } else {
                            Text("Starting Actor: \(actorList.first!.name)")
                        }
                           
                        if (destinationActor == nil) {
                            Text("Choose a destination actor")
                            HStack { // Search Bar
                                Image(systemName: "magnifyingglass")
                                TextField("Search for an actor here", text: $endSearchText)
                                    .disableAutocorrection(true)
                                if (!endSearchText.isEmpty) {
                                    Button(action: {endSearchText = ""}, label: {
                                        Image(systemName: "xmark")
                                    })
                                }
                            }
                            ForEach(endSearchActors) { act in
                                Button(action: {
                                    destinationActor = act
                                }, label: {
                                    Text(act.name)
                                })
                            }
                        } else {
                            Text("Destination Actor: \(destinationActor!.name)")
                        }
                    }
                } else {
                    
                    HStack {
                        VStack{
                            ForEach (actorList) { selAct in
                                Text(selAct.name)
                            }
                        }
                        VStack{
                            ForEach (showList) { selShow in
                                Text(selShow.name)
                            }
                        }
                    }
                    
                    if (!won) {
                        if (actorList.count > showList.count) {
                            ScrollView(.horizontal) {
                                ForEach(actorList.last!.shows) { show in
                                    Button(action: {
                                        showList.append(show)
                                    }) {
                                        Text(show.name)
                                    }
                                }
                            }
                        } else {
                            ScrollView(.horizontal) {
                                ForEach(getActors(showIn: showList.last!, actors: modelData.actors)) { act in
                                    Button(action: {
                                        //actorList.append(act)
                                        addActor(act: act)
                                    }) {
                                        Text(act.name)
                                    }
                                }
                            }
                        }
                        
                        Text("Destination Actor: \(destinationActor!.name)")
                    } else {
                        Text("Congrats you won!")
                        Text("Game over")
                    }
                    
                }
            }
        }
        .navigationTitle("Actor Reference Game")
    }
}

struct ActorReferenceGame_Previews: PreviewProvider {
    static var previews: some View {
        ActorReferenceGame()
            .environmentObject(ModelData())
    }
}

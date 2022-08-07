//
//  ActorReferenceGame.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/25/22.
//

import SwiftUI

struct ActorReferenceGame: View {
    
    var body: some View {
        Text("TODO")
    }
    
    /*
    
    @EnvironmentObject var modelData : ModelData
    
    @State var actorList = [Actor]()
    @State var showList = [Show]()
    @State var destinationActor: Actor? = nil
    @State var won = false
    @State var invalidParing = false
    @State var gameStarted = false
    
    @State var answerShown = false
    @State var correctPath = [Actor]()
    
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
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Connect the actors by shows!")
                        .font(.headline)
                    Text("Select actors and shows to reach your destination actor.")
                }
                .padding(.top, 5)
                .padding(.bottom, 5)
                
                if (!gameStarted) {
                    VStack (alignment: .leading) {
                        if (actorList.isEmpty) {
                            Text("Choose a starting actor")
                                .font(.headline)
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
                                .font(.headline)
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
                            VStack(alignment: .center) {
                                Text("Destination Actor: \(destinationActor!.name)")
                            }
                        }
                    }
                    
                    VStack (alignment: .center) {
                        Button(action: {
                            if (!actorList.isEmpty && destinationActor != nil) {
                                let returned = findShortestPath(actorList: modelData.actors, startActor: actorList[0], destinationActor: destinationActor!)
                                if (returned.isEmpty) {
                                    invalidParing = true
                                    destinationActor = nil
                                    actorList.remove(at: 0)
                                } else {
                                    invalidParing = false
                                    correctPath = returned
                                    gameStarted = true
                                }
                            } else {
                                invalidParing = true
                            }
                        }) {
                            Text("Start Game")
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                    }
                    
                    if (invalidParing) {
                        VStack {
                            Text("Invalid Actor Selection")
                                .font(.headline)
                            Text("Either a path between the actors could not be found or a selection is missing.")
                        }
                        .padding(5)
                        .foregroundColor(.red)
                        .background(.red.opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                } else {
                
                    Toggle(isOn: $answerShown, label: {
                        Text("Show Answer?")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    if (answerShown) {
                        VStack(alignment: .leading) {
                            Text("Answer:")
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(correctPath) { act in
                                        Text(act.name)
                                            .padding(5)
                                            .background(.blue)
                                            .cornerRadius(5)
                                    }
                                }
                                .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 2)
                        .padding(.bottom, 5)
                        .background(.quaternary.opacity(0.25))
                        .cornerRadius(5)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    }
                    
                    
                    HStack {
                        VStack{
                            ForEach (actorList) { selAct in
                                Text(selAct.name)
                                    .padding(5)
                                    .background(.blue)
                                    .cornerRadius(5)
                            }
                        }
                        VStack{
                            ForEach (showList) { selShow in
                                Text(selShow.name)
                                    .padding(5)
                                    .background(.red)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .foregroundColor(.white)
                    
                    
                    if (!won) {
                        VStack (alignment: .center) {
                            if (actorList.count > showList.count) {
                                //ScrollView(.horizontal) {
                                ForEach(actorList.last!.shows) { show in
                                    Button(action: {
                                        showList.append(show)
                                    }) {
                                        Text(show.name)
                                    }
                                    //}
                                }
                            } else {
                                //ScrollView(.horizontal) {
                                ForEach(getActors(showIn: showList.last!, actors: modelData.actors)) { act in
                                    Button(action: {
                                        //actorList.append(act)
                                        addActor(act: act)
                                    }) {
                                        Text(act.name)
                                    }
                                }
                                //}
                            }
                            
                            Text("Destination Actor: \(destinationActor!.name)")
                        }
                    } else {
                        VStack {
                            Text("Congrats you won!")
                                .font(.title)
                            if (actorList.count == correctPath.count) {
                                Text("Even better, you're path between the actors was optimal")
                            } else {
                                Text("Great job finding a path. Here's another path with less steps:")
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(correctPath) { act in
                                            Text(act.name)
                                                .padding(5)
                                                .background(.blue)
                                                .cornerRadius(5)
                                        }
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        .background(.green.opacity(0.25))
                        .cornerRadius(5)
                    }
                    
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
        }
        .navigationTitle("Actor Reference Game")
    }
     */
}

struct ActorReferenceGame_Previews: PreviewProvider {
    static var previews: some View {
        ActorReferenceGame()
            .environmentObject(ModelData())
    }
}

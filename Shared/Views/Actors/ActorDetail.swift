//
//  ActorDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI

struct ActorDetail: View {
    
    @EnvironmentObject var modelData: ModelData
        
    var actor: Actor
    
    @State var actorEdited: Actor
    
    @State private var isPresented = false // Edit menu var
    
    var actorIndex: Int {
        modelData.actors.firstIndex(where: { $0.id == actor.id})!
    }
    
    init(actor: Actor) {
        self.actor = actor
        _actorEdited = State(initialValue: actor)
        //print(showEdited)
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text(actor.name)
                    .font(.title)
                    .padding()
                Spacer()
            
                VStack (alignment: .leading) {
                    Text("Shows "+actor.name+" has appeared in:")
                        .padding()
                    
                    ForEach(actor.shows.sorted(by: >), id:\.key) { showId, showName in
                        NavigationLink(destination: ShowDetail(show: modelData.shows.first(where: { $0.id == showId
                        })!)) {
                            HStack {
                                Text(showName)
                            }
                        }
                        .padding()
                    }
                    
                }
            }
        }
        
        .navigationTitle(actor.name)
        .navigationBarTitleDisplayMode(.inline)
        //.navigationBarBackButtonHidden(false)
        
        .navigationBarItems(trailing: Button("Edit") {
                    isPresented = true
                })
        
        .sheet(isPresented: $isPresented) {
            NavigationView {
                ActorDetailEdit(isPresented: self.$isPresented, actor: $actorEdited)
                //ShowDetailEdit(isPresented: self.$isPresented)
                    .navigationTitle(actor.name)
                    .navigationBarItems(leading: Button("Cancel") {
                        actorEdited = actor
                        isPresented = false
                    }, trailing: Button("Done") {
                        //print(showEdited)
                        if (actorEdited != actor) {
                            if (actorEdited.name != actor.name) {
                                updateActor(act: actorEdited, actorNameEdited: true)
                            } else {
                                updateActor(act: actorEdited, actorNameEdited: false)
                            }
                        }
                        isPresented = false
                    })
            }
        }
    }
    
}

struct ActorDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            //ActorDetail(actorId: "zdvmjx5mhIZnjzTP6KlZ")
                //.environmentObject(modelData)
        }
    }
}

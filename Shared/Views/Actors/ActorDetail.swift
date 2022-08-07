//
//  ActorDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI

struct ActorDetail: View {
    
    var body: some View {
        Text("Temp")
    }
    /*
    @EnvironmentObject var modelData: ModelData
    
    let actorId: String
    
    var actor: Actor {
        //print(modelData.actors)
        return modelData.actors.first(where: { $0.id == actorId })!
    }
    
    @State private var isPresented = false // Edit menu var
    //var showNames = [String]()
    
    var showNames: [String] {
        var output = [String]()
        for (_, showName) in actor.shows {
            output.append(showName)
        }
        return output
    }
     
    //var showIds = [String]()
    
    var showIds: [String] {
        var output = [String]()
        for (showId, _) in actor.shows {
            output.append(showId)
        }
        return output
    }
     
    
    var actorIndex: Int {
        modelData.actors.firstIndex(where: { $0.id == actor.id})!
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
                    
                    ForEach(0..<showIds.count) { showInd in
                        NavigationLink(destination: ShowDetail(show: modelData.shows.first(where: { $0.id == showIds[showInd]
                        })!)) {
                            HStack {
                                Text(showNames[showInd])
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
                //ActorDetailEdit(isPresented: self.$isPresented, actor: actor, actorIndex: actorIndex)
                ActorDetailEdit()
                    .navigationTitle(actor.name)
                    .navigationBarItems(trailing: Button("Done") {
                        isPresented = false
                    })
            }
        }
    }
     */
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

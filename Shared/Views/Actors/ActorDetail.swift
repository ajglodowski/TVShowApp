//
//  ActorDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI

struct ActorDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var actor : Actor
    
    @State private var isPresented = false // Edit menu var
    
    var showList : [Show] {
        actor.shows
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
                    ForEach(showList) { show in
                        NavigationLink(destination: ShowDetail(show: modelData.shows.first(where: {$0.equals(input: show)})!)) {
                            ListShowRow(show: show)
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
                ActorDetailEdit(isPresented: self.$isPresented, actor: actor, actorIndex: actorIndex)
                    .navigationTitle(actor.name)
                    .navigationBarItems(trailing: Button("Done") {
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
            ActorDetail(actor: modelData.actors[0])
                .environmentObject(modelData)
        }
    }
}

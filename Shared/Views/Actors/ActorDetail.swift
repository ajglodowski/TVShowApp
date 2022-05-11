//
//  ActorDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI

struct ActorDetail: View {
    
    var actor : Actor
    
    @State private var isPresented = false // Edit menu var
    
    var showList : [Show] {
        actor.shows
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
                        NavigationLink(destination: ShowDetail(show: show)) {
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
                ActorDetailEdit(isPresented: self.$isPresented, actor: actor)
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

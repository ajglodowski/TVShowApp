//
//  ActorList.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/12/22.
//

import SwiftUI

struct ActorList: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @State private var searchText = ""
    
    var searchActors: [Actor] {
        modelData.actors.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        List {
            if (searchText.isEmpty) {
                ForEach(modelData.actors.sorted { $0.name < $1.name }) { specActor in
                    NavigationLink(destination: ActorDetail(actorId: specActor.id)) {
                        HStack {
                            Text(specActor.name)
                            Spacer()
                        }
                    }
                }
            } else {
                ForEach(searchActors) { specActor in
                    NavigationLink(destination: ActorDetail(actorId: specActor.id)) {
                        HStack {
                            Text(specActor.name)
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Actor List")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .disableAutocorrection(true)
    }

}

struct ActorList_Previews: PreviewProvider {
    static var previews: some View {
        ActorList()
            .environmentObject(ModelData())
    }
}

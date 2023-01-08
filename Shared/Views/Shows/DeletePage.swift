//
//  DeletePage.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/15/21.
//

import SwiftUI

struct DeletePage: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var body: some View {
        List {
            ForEach(modelData.shows) { show in
                
                HStack {
                    Text(show.name)
                }
            }
            .onDelete(perform: self.deleteItem)
        }
        .navigationTitle("Delete Shows")
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        //self.modelData.shows.remove(atOffsets: indexSet)
    }
    
}

struct DeletePage_Previews: PreviewProvider {
    static var previews: some View {
        DeletePage()
            .environmentObject(ModelData())
    }
}

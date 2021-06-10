//
//  ContentView.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        //WatchList()
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

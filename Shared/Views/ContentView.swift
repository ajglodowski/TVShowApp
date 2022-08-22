//
//  ContentView.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var body: some View {
        if (modelData.loggedIn) {
            Home()
        } else {
            Login(loggedIn: $modelData.loggedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

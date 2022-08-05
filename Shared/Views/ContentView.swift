//
//  ContentView.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var loggedIn = false
    
    var body: some View {
        if (loggedIn) {
            Home()
        } else {
            Login(loggedIn: $loggedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

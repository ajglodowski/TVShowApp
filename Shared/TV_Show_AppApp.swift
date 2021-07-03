//
//  TV_Show_AppApp.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI

@main struct TV_Show_AppApp: App {
    
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
            
            //.preferredColorScheme(.dark)
        }
    }
}

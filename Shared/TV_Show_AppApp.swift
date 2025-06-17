//
//  TV_Show_AppApp.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import FirebaseCore
import Firebase
//import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main struct TV_Show_AppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var modelData = ModelData()
    @StateObject private var supabaseModelData = SupbaseModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(supabaseModelData)
            /*
                .modelContainer(for: [
                    //ShowUserSpecificDetails.self,
                    LastUserFetch.self
                ])
             */
             
            //.preferredColorScheme(.dark)
        }
    }
}

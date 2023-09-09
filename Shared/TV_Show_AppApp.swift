//
//  TV_Show_AppApp.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import FirebaseCore
import Firebase
import InstantSearchSwiftUI
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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
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

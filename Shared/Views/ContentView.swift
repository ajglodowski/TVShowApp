//
//  ContentView.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var modelData : ModelData
    
    //@Environment(\.modelContext) private var modelContext
    
    var body: some View {
        if (modelData.entered && Auth.auth().currentUser != nil) {
            TabView {
                Home()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                DiscoverTab()
                    .tabItem {
                        Label("Discover", systemImage: "sparkles")
                    }
                CurrentUserProfileDetail()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .task {
                //updateFetchDate(context: modelContext, newFetch: Date())
            }
            /*
            .task(id: modelData.shows) {
                let toConvert = modelData.shows.filter { $0.addedToUserShows }.map { $0.userSpecificValues! }
                print(toConvert)
                syncUserSpecificDetailsToData(context: modelContext, data: toConvert)
            }
             */
        } else {
            Login(loggedIn: $modelData.entered)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

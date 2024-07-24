//
//  ContentView.swift
//  Shared
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var notAuthenticated: Bool = supabase.auth.currentUser == nil
    
    var body: some View {
        if (!notAuthenticated) {
            TabView {
                Home()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                /*
                DiscoverTab()
                    .tabItem {
                        Label("Discover", systemImage: "sparkles")
                    }
                 */
                CurrentUserProfileDetail()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        } else {
            Text("Not Logged In")
                .sheet(isPresented: $notAuthenticated) {
                    Login()
                }
            
        }
    }
}

#Preview {
    ContentView(notAuthenticated: true)
}

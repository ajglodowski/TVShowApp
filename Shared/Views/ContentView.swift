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
                Tab("Home", systemImage: "house.fill") {
                    Home()
                }
                
                Tab("Discover", systemImage: "magnifyingglass", role: .search) {
                    DiscoverTab()
                }
                
        
//                Tab("Profile", systemImage: "person.fill") {
//                    CurrentUserProfileDetail()
//                }
            }
            .defaultAdaptableTabBarPlacement(.sidebar)
            .tabBarMinimizeBehavior(.onScrollDown)
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

//
//  FollowerList.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import SwiftUI

struct FollowerList: View {
    
    var followerList: [String: String] // ID: Username
    var type: String
    
    var body: some View {
        List {
            ForEach(followerList.sorted(by: >), id:\.key) { id, username in
                NavigationLink(destination: ProfileDetail(id: id)) {
                    HStack {
                        Text(username)
                    }
                }
            }
        }
        .navigationTitle(type)
        .listStyle(.automatic)
    }
}


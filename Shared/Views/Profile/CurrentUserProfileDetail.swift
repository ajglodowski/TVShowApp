//
//  CurrentUserProfileDetail.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import SwiftUI
import Firebase

struct CurrentUserProfileDetail: View {
    
    @ObservedObject var modelData = ModelData()
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileDetail(id: Auth.auth().currentUser!.uid)
                Button(action: {
                    try! Auth.auth().signOut()
                }) {
                    Text("Sign Out")
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct CurrentUserProfileDetail_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileDetail()
    }
}

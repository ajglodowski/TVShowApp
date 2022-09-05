//
//  CurrentUserProfileDetail.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import SwiftUI
import Firebase

struct CurrentUserProfileDetail: View {
    var body: some View {
        NavigationView {
            ProfileDetail(id: Auth.auth().currentUser!.uid)
        }
        .navigationViewStyle(.stack)
    }
}

struct CurrentUserProfileDetail_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileDetail()
    }
}

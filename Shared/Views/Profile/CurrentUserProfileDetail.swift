//
//  CurrentUserProfileDetail.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/5/22.
//

import SwiftUI
import Firebase

struct CurrentUserProfileDetail: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var currentUserId: String? { modelData.currentUser?.id }
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
        } catch {
            dump(error)
        }
    }
    
    var body: some View {
        NavigationView {
            if (currentUserId != nil) {
                VStack {
                    ProfileDetail(id: currentUserId!)
                    Button(action: {
                        Task {
                            await signOut()
                        }
                    }) {
                        Text("Sign Out")
                    }
                    .buttonStyle(.bordered)
                }
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

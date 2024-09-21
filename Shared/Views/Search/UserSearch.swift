//
//  UserSearch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/4/24.
//

import SwiftUI

struct UserSearch: View {
    
    @ObservedObject var profileSearchVm = ProfileSearchViewModel()
    
    @State var profileSearchText = ""
    
    var profilesReturned: [Profile] { profileSearchVm.profilesReturned }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Search for Users")
                .font(.title)
            Text("Unfortunately at this point you have to enter in the exact username 😔")
            HStack { // Search Bar
                Image(systemName: "magnifyingglass")
                TextField("Search for a user", text: $profileSearchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                if (!profileSearchText.isEmpty) {
                    Button(action: {
                        profileSearchText = ""
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            VStack (alignment: .leading) {
                ForEach(profilesReturned) { profile in
                    ProfileTile(profileId: profile.id)
                }
            }
            //.listStyle(.automatic)
        }
        .task(id: profileSearchText) {
            if (!profileSearchText.isEmpty) {
                await profileSearchVm.searchForUser(username: profileSearchText)
            }
        }
    }
}

#Preview {
    UserSearch()
}

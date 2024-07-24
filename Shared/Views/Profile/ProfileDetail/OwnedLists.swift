//
//  OwnedLists.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/23/24.
//

import SwiftUI

struct OwnedLists: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @StateObject var vm = OwnedListsViewModel()
    
    @State var newListPresented = false
    @State var newList: ShowList = ShowList(list: SupabaseShowList(creator: "Invalid User"), entries: [])
    
    var profile: Profile
    var currentProfileId: String? { modelData.currentUser?.id }
    
    var isCurrentProfile: Bool { profile.id == currentProfileId }
    
    var showLists: [Int]? { vm.lists }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (!isCurrentProfile) {
                Text("\(profile.username)'s Lists")
                    .font(.headline)
            } else {
                Text("Your Lists")
                    .font(.headline)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    if (isCurrentProfile) {
                        VStack {
                            Button(action: {
                                newList = ShowList(list: SupabaseShowList(creator: currentProfileId!), entries: [])
                                newListPresented = true
                            }) {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                    Text("Create a new list")
                                        .font(.headline)
                                }
                                .frame(width: 150, height: 150)
                            }
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(alignment: .center)
                            .background(.green)
                            .cornerRadius(10)
                        }
                        .padding(5)
                    }
                    if (showLists != nil) {
                        ForEach(showLists!, id:\.self) { showListId in
                            NavigationLink(destination: ShowListDetail(listId: showListId)) {
                                ShowListTile(showListId: showListId)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 5)
                            }
                        }
                    }
                }
            }
        }
        .task {
            await vm.loadLists(profileId: profile.id, currentUser: isCurrentProfile)
        }
        .sheet(isPresented: $newListPresented) {
            ShowListDetailEdit(showList: $newList, isPresented: $newListPresented)
        }
    }
}

#Preview {
    OwnedLists(profile: MockProfile)
}

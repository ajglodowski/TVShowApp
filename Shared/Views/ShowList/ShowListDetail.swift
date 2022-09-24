//
//  List.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import SwiftUI

struct ShowListDetail: View {
    
    var listId: String
    
    @ObservedObject var modelData = ModelData()
    @StateObject var listVm = ShowListViewModel()
    @StateObject var profileVm = ProfileViewModel()
    
    @State var listObj: ShowList? = nil
    
    var likedByCurrentUser: Bool {
        if (listObj != nil &&
            modelData.currentUser != nil &&
            modelData.currentUser!.likedShowLists != nil &&
            modelData.currentUser!.likedShowLists!.contains(listObj!.id)) {
            return true
        } else {
            return false
        }
    }
    
    var ownedList: Bool {
        if (listObj != nil &&
            modelData.currentUser != nil &&
            listObj!.profile.id == modelData.currentUser!.id) {
            return true
        } else {
            return false
        }
    }
    
    @State var searchText: String = ""
    
    var displayedShows: [Show] {
        let listObj = listVm.showListObj
        if (listObj != nil) {
            let out = listObj!.shows
            if (!searchText.isEmpty) {
                return out.filter { $0.name.contains(searchText) }
            } else {
                return out
            }
        } else {
            return [Show]()
        }
    }
    
    var body: some View {
        
        //List {
            VStack(alignment: .leading) {
                if (listObj != nil) {
                    //
                    header
                    
                    showSection
                } else {
                    Text("Here")
                }
            }
            .refreshable {
                // Refresh here
                await listVm.loadList(id: listId)
                self.listObj = listVm.showListObj
            }
            .task {
                // Load here
                await listVm.loadList(id: listId)
                self.listObj = listVm.showListObj
            }
        //}
        //.listStyle(.plain)
    }
    
    var header: some View {
        VStack(alignment:.leading) {
            let listObj = listVm.showListObj
            if (listObj != nil) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(listObj!.name)
                            .font(.title)
                        // Public private toggle
                        if (ownedList) {
                            if (listObj!.priv) {
                                Button(action: {
                                    // Make public
                                }) {
                                    Text("Private List")
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Button(action: {
                                    // Make privatte
                                }) {
                                    Text("Public List")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        Spacer()
                        // Like Button
                        Button(action: {
                            if (likedByCurrentUser) {
                                dislikeList(listId: listObj!.id)
                            } else {
                                likeList(listId: listObj!.id)
                            }
                        }) {
                            if (likedByCurrentUser) {
                                Image(systemName: "heart.fill")
                                    .tint(.pink)
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "heart")
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    Text(listObj!.description)
                    NavigationLink(destination: ProfileDetail(id: listObj!.profile.id)) {
                        Text("List Creator: @\(listObj!.profile.username)")
                            .italic()
                            .padding(5)
                            .background(.tertiary)
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
    
    @State var editing: Bool = false
    @State var editingShows: [Show] = [Show]()
    @State var editingOrdered: Bool = false
    
    func move(from source: IndexSet, to destination: Int) {
        editingShows.move(fromOffsets: source, toOffset: destination)
    }
    
    var showSection: some View {
        
        VStack {
            let listObj = listVm.showListObj
            if (listObj != nil) {
                VStack {
                    
                    // Control Group
                    HStack {
                        // List order
                        if (listObj!.ordered && !editing) {
                            //
                        }
                        Spacer()
                        // Ordered? buttons
                        if (editing) {
                            HStack {
                                Picker(selection: $editingOrdered, label: Text("List Ordered?")) {
                                    Text("Unordered").tag(false)
                                    Text("Ordered").tag(true)
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        Spacer()
                        if (ownedList) {
                            if (!editing) {
                                Button(action: {
                                    editing = true
                                    editingShows = listObj!.shows
                                    editingOrdered = listObj!.ordered
                                }) {
                                    Text("Edit List")
                                }
                                .buttonStyle(.bordered)
                            } else {
                                HStack {
                                    Button(action: {
                                        editing = false
                                        editingShows = listObj!.shows
                                        editingOrdered = listObj!.ordered
                                    }) {
                                        Text("Cancel Edits")
                                    }
                                    .buttonStyle(.bordered)
                                    Button(action: {
                                        editing = false
                                        // Update Firestore shows and ordered
                                        if (editingShows != listObj!.shows) {
                                            // update
                                        }
                                        if (editingOrdered != listObj!.ordered) {
                                            // update
                                        }
                                        
                                    }) {
                                        Text("Save Edits")
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                    }
                    
                    
                    // Listing the shows
                    if (!editing) {
                        List {
                            ForEach(Array(displayedShows.enumerated()), id: \.offset) { showPlace, show in
                                HStack {
                                    if (listObj!.ordered) {
                                        Text("\(showPlace+1).")
                                    }
                                    ListShowRow(show: show)
                                }
                            }
                        }
                        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                    } else {
                        List {
                            ForEach(Array(editingShows.enumerated()), id: \.offset) { showPlace, show in
                                HStack {
                                    if (editingOrdered) {
                                        Text("\(showPlace+1).")
                                    }
                                    ListShowRow(show: show)
                                    Button(action: {
                                        editingShows.removeAll(where: { $0 == show})
                                    }) {
                                        Text("Remove from List")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.red)
                                }
                            }
                            .onMove(perform: move)
                        }
                    }
                }
            }
        }
        
    }
}

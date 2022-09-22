//
//  List.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import SwiftUI

struct ShowListDetail: View {
    
    var listId: String
    
    var modelData = ModelData()
    var listVm = ShowListViewModel()
    var profileVm = ProfileViewModel()
    
    @State var listObj: ShowList? = nil
    
    var body: some View {
        
        //ScrollView {
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
    }
    
    var header: some View {
        VStack {
            var listObj = listVm.showListObj
            if (listObj != nil) {
                VStack {
                    HStack {
                        Text(listObj!.name)
                            .font(.title)
                        if (listObj!.profile.id == modelData.currentUser!.id) {
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
                    }
                    Text(listObj!.description)
                    Text("List Creator: @\(listObj!.profile.username)")
                        .italic()
                }
            }
        }
    }
    
    var displayedShows: [Show] {
        var listObj = listVm.showListObj
        if (listObj != nil) {
            let out = listObj!.shows
            return out
        } else {
            return [Show]()
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
            var listObj = listVm.showListObj
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
                        if (listObj!.profile.id == modelData.currentUser!.id) {
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

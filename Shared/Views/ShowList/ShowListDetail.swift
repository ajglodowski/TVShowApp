//
//  List.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import SwiftUI

struct ShowListDetail: View {
    
    var listId: Int
    
    @EnvironmentObject var modelData : ModelData
    @StateObject var listVm = ShowListViewModel()
    
    @State private var editPresented = false
    @State var listEdited = ShowList(list: SupabaseShowList(creator: "Invalid User"), entries: [])
    
    var listObj: ShowList? { listVm.showListObj }
    
    func reloadData() async { await listVm.loadList(id: listId) }
    
    var listShows: [Show] { listObj?.shows.map { $0.show } ?? [] }
    
    var ownedList: Bool {
        if (listObj != nil &&
            modelData.currentUser != nil &&
            listObj!.creator == modelData.currentUser!.id) {
            return true
        }
        return false
    }
    
    @State var editing: Bool = false
    @State var editingShows: [Show] = [Show]()
    @State var editingOrdered: Bool = false
    
    @State var searchText: String = ""
    var displayedShows: [Show] {
        if (!searchText.isEmpty && !listShows.isEmpty) {
            return listShows.filter { $0.name.contains(searchText) }
        }
        return listShows
    }
    
    var body: some View {
        
        List {
            if (listObj != nil) {
                ShowListHeader(listObj: listObj!, ownedList: ownedList, listVm: listVm, listEdited: $listEdited, editPresented: $editPresented)
                
                ProfileTile(profileId: listObj!.creator)

                ShowListEditButtons(editing: $editing, editingShows: $editingShows, editingOrdered: $editingOrdered, listShows: listShows, listObj: listObj!, ownedList: ownedList, reloadData: reloadData)
                
                if (editing) { ShowListShowSearch(editingShows: $editingShows) }
                
                if (!editing) {
                    ForEach(Array(displayedShows.enumerated()), id: \.offset) { showPlace, show in
                        NavigationLink(destination: ShowDetail(showId: show.id)) {
                            HStack {
                                if (listObj!.ordered) { Text("\(showPlace+1).") }
                                ListShowRow(show: show)
                            }
                        }
                    }
                } else {
                    ForEach(editingShows) { show in
                        HStack {
                            ListShowRow(show: show)
                            Button(action: { editingShows.removeAll(where: { $0.id == show.id }) } ) {
                                HStack {
                                    Image(systemName: "xmark")
                                    Text("Remove")
                                }
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.red)
                        }
                    }
                    .onMove(perform: move)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(listObj?.name ?? "Loading List")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await reloadData() }
        .task { await reloadData() }
        .sheet(isPresented: $editPresented) {
            NavigationView {
                ShowListDetailEdit(showList: $listEdited, isPresented: self.$editPresented)
                    .navigationTitle(listObj?.name ?? "Loading List")
                    .navigationBarItems(leading: Button("Cancel") {
                        listEdited = listObj!
                        editPresented = false
                    }, trailing: Button("Done") {
                        if (listEdited != listObj!) {
                            Task {
                                await updateShowListInfo(showList: listEdited)
                                await reloadData()
                            }
                        }
                        editPresented = false
                    })
            }
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        editingShows.move(fromOffsets: source, toOffset: destination)
    }
    
}

//
//  ShowListEditButtons.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/31/24.
//

import SwiftUI

struct ShowListEditButtons: View {
    
    @Binding var editing: Bool
    @Binding var editingShows: [Show]
    @Binding var editingOrdered: Bool
    var listShows: [Show]
    var listObj: ShowList
    var ownedList: Bool
    var reloadData: () async -> Void
    
    func startEditing() {
        editing = true
        editingShows = listShows
        editingOrdered = listObj.ordered
    }
    
    func cancelEdits() {
        editing = false
        editingShows = listShows
        editingOrdered = listObj.ordered
    }
    
    func submitEdits() {
        editing = false
        if (editingShows != listShows) {
            Task {
                let success = await updateListShows(listId: listObj.id, shows: editingShows, previousShows: listShows)
                await reloadData()
            }
        }
        if (editingOrdered != listObj.ordered) {
            Task {
                let success = await updateListOrdered(listId: listObj.id, listOrdered: editingOrdered)
                await reloadData()
            }
        }
    }
    
    var body: some View{
        HStack {
            if (ownedList) {
                if (!editing) {
                    Button(action: startEditing) {
                        Text("Edit List")
                    }
                    .buttonStyle(.bordered)
                } else {
                    HStack {
                        Picker(selection: $editingOrdered, label: Text("List Ordered?")) {
                            Text("Unordered").tag(false)
                            Text("Ordered").tag(true)
                        }
                        .pickerStyle(.segmented)
                        
                        Button(action: cancelEdits) {
                            HStack {
                                Image(systemName: "xmark")
                                Text("Cancel")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Button(action: submitEdits) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Save")
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
        }
    }
}

#Preview {
    @State var editing: Bool = true
    @State var editingShows: [Show] = []
    @State var editingOrdered: Bool = true
    
    var showObj = ShowList(list: SupabaseShowList(creator: "-1"), entries: [])
    
    func dummy() {}
    
    return ShowListEditButtons(editing: $editing, editingShows: $editingShows, editingOrdered: $editingOrdered, listShows: [], listObj: showObj, ownedList: true, reloadData: dummy)
}

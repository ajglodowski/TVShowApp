//
//  ShowListHeader.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/25/24.
//

import SwiftUI

struct ShowListHeader: View {
    
    var listObj: ShowList
    var ownedList: Bool
    @ObservedObject var listVm: ShowListViewModel
    @Binding var listEdited: ShowList
    @Binding var editPresented: Bool
    
    func reloadData() async {
        await listVm.loadList(id: listObj.id)
    }
    
    var body: some View {
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
                                    //makeListPublic(listId: listObj!.id)
                                    Task {
                                        await reloadData()
                                    }
                                }) {
                                    Text("Private List")
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Button(action: {
                                    //makeListPrivate(listId: listObj!.id)
                                    Task {
                                        await reloadData()
                                    }
                                }) {
                                    Text("Public List")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        Spacer()
                        if (ownedList) {
                            Button(action: {
                                listEdited = listObj!
                                editPresented = true
                            }) {
                                Text("Edit List")
                            }
                            .buttonStyle(.bordered)
                        }
                        
                    }
                    Text(listObj!.description)
                    ShowListLikeSection()
                }
            }
        }
        .padding()
    }
}

//
//  ShowListDetailEdit.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/30/22.
//

import SwiftUI

struct ShowListDetailEdit: View {
    
    @Binding var showList: ShowList
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            
            Section(header: Text("List Title:")) {
                HStack {
                    TextField("List Title", text: $showList.name)
                        .disableAutocorrection(true)
                        .font(.title)
                    if (!showList.name.isEmpty) {
                        Button(action: { showList.name = ""}, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
            }
            
            Section(header: Text("List Description:")) {
                HStack {
                    TextField("List Description", text: $showList.description, axis: .vertical)
                    if (!showList.description.isEmpty) {
                        Button(action: { showList.description = ""}, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
            }
            
            Section(header: Text("Private?:")) {
                Toggle(isOn: $showList.priv, label: {
                    Text("Private?")
                })
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            Section(header: Text("Ordered?:")) {
                Toggle(isOn: $showList.ordered, label: {
                    Text("Ordered?")
                })
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            Section(header: Text("ID:")) {
                Text("ID: \(showList.id)")
            }
            
        }
    }
}


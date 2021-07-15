//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine


struct ShowDetailEdit: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @Binding var isPresented: Bool
    
    var show : Show
    
    var showIndex: Int {
        modelData.shows.firstIndex(where: { $0.id == show.id }) ?? (modelData.shows.firstIndex(where: { $0.name == show.name }) ?? -1)
    }
    
    var body: some View {
        
        //ContentView.navigationBar.navigationBarHidden(true)
        
        List {
            
            Section(header: Text("Show Title:")) {
                TextField("Show Title", text: $modelData.shows[showIndex].name)
                    .font(.title)
            }
            //.padding()
            
            Section(header: Text("Show Details:")) {
                Toggle(isOn: $modelData.shows[showIndex].watched, label: {
                    Text("Watched?")
                })
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Show Length:")
                    Picker("Length", selection: $modelData.shows[showIndex].length) {
                        ForEach(ShowLength.allCases) { length in
                            Text(length.rawValue).tag(length)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                
                HStack {
                    Text("Service: " + modelData.shows[showIndex].service.rawValue)
                    Spacer()
                    Picker("Change Service", selection: $modelData.shows[showIndex].service) {
                        ForEach(Service.allCases) { service in
                            Text(service.rawValue).tag(service)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(.white)
                    .padding(7.5)
                    .background(Color.blue.opacity(0.80).cornerRadius(8))
                }
                .padding()
            }
            
            
            Section(header: Text("Show Status:")) {
                TextField("Show Status", text: $modelData.shows[showIndex].status)
            }
            
            Section(header: Text("Internal ID:")) {
                TextField("ID", value: $modelData.shows[showIndex].id, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            
             
            //TODO
            /*
            Button(action: {
                //modelData.shows.remove(at: showIndex)
                self.isPresented = false
                modelData.shows.remove(at: showIndex)
            }, label: {
                Text("Delete Show")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
 */
             
        }
        .listStyle(InsetGroupedListStyle())
    }
}
/*
struct ShowDetailEdit_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ShowDetailEdit(isPresented: true, show: modelData.shows[30])
                .environmentObject(modelData)
        }
    }
}
*/

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
        modelData.shows.firstIndex(where: { $0.equals(input: show) }) ?? -1
    }
    
    func actorIndex(actor: Actor) -> Int {
        modelData.actors.firstIndex(where: { $0.id == actor.id }) ?? (modelData.actors.firstIndex(where: { $0.name == actor.name }) ?? -1)
    }
    
    var actorArr : [Actor] {
        getActors(showIn: show, actors: modelData.actors)
    }
    
    @State private var searchText = ""
    var searchActors: [Actor] {
        modelData.actors.filter { act in
            act.name.contains(searchText)
        }
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
                
                // Watched
                Toggle(isOn: $modelData.shows[showIndex].watched, label: {
                    Text("Watched?")
                })
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
                
                // Discovered
                Toggle(isOn: $modelData.shows[showIndex].discovered, label: {
                    Text("Discovered?")
                })
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
                
                // Show Length
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
                
                // Service
                HStack {
                    Text("Service: " + modelData.shows[showIndex].service.rawValue)
                    Spacer()
                    Picker("Change Service", selection: $modelData.shows[showIndex].service) {
                        ForEach(Service.allCases) { service in
                            Text(service.rawValue).tag(service)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            
            // Status
            Section(header: Text("Show Status:")) {
                HStack {
                    Text("Status: " + modelData.shows[showIndex].status.rawValue)
                    Spacer()
                    Picker("Change Status", selection: $modelData.shows[showIndex].status) {
                        ForEach(Status.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .buttonStyle(.bordered)
                }
                //.padding()
                
                // Airdate
                if (modelData.shows[showIndex].status == Status.CurrentlyAiring) {
                    HStack {
                        Text("Airdate: " + modelData.shows[showIndex].airdate.rawValue)
                        Spacer()
                        Picker("Change Airdate", selection: $modelData.shows[showIndex].airdate) {
                            ForEach(AirDate.allCases) { airdate in
                                Text(airdate.rawValue).tag(airdate)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .buttonStyle(.bordered)
                    }
                    //.padding()
                }
            }
            
            // Current Actors
            Section(header: Text("Actors:")) {
                ForEach(actorArr) { act in
                    HStack {
                        Text(act.name)
                        Spacer()
                        Spacer()
                        Button(action: {
                            modelData.actors[actorIndex(actor: act)].shows = modelData.actors[actorIndex(actor: act)].shows.filter { $0 != show}
                        }, label: {
                            Text("Remove from Show")
                                //.font(.title)
                        })
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            
            // Add an existing actor
            Section(header: Text("Add an existing actor")) {
                HStack { // Search Bar
                    Image(systemName: "magnifyingglass")
                    TextField("Search for an actor here", text: $searchText)
                    if (!searchText.isEmpty) {
                        Button(action: {searchText = ""}, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
                //.padding()
                .background(Color(.systemGray5))
                .cornerRadius(20)
                
                ForEach(searchActors) { act in
                    Button(action: {
                        modelData.actors[actorIndex(actor: act)].addShow(toAdd: show)
                    }, label: {
                        Text(act.name)
                    })
                }
            }
            
            
            // Add a new actor
            Section(header: Text("Add a new actor")) {
                Button(action: {
                    print("1")
                    var new = Actor()
                    print("2")
                    new.shows.append(show)
                    print("3")
                    //newShow = new
                    modelData.actors.append(new)
                    print("4")
                    //ActorDetail(actor: new)
                }, label: {
                    Text("Add a new Actor")
                        //.font(.title)
                })
                .buttonStyle(.bordered)
                //ActorEditList(show: modelData.shows[showIndex])
            }
            
            
            
            // ID
            Section(header: Text("Internal ID:")) {
                //TextField("ID", value: $modelData.shows[showIndex].id, formatter: NumberFormatter())
                    //.keyboardType(.numberPad)
                Text("ID: "+modelData.shows[showIndex].id)
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

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
    
    @State private var showName: String = ""
    
    @Binding var isPresented: Bool
    
    /*
    
    var show : Show
    
     */
    
    @Binding var show: Show
        
    /*
    var showIndex: Int {
        modelData.shows.firstIndex(where: { $0.id == show.id })!
    }
    
    func actorIndex(actor: Actor) -> Int {
        modelData.actors.firstIndex(where: { $0.id == actor.id }) ?? (modelData.actors.firstIndex(where: { $0.name == actor.name }) ?? -1)
    }
    */
    
    var body: some View {
        
        //ContentView.navigationBar.navigationBarHidden(true)
        
        List {
            
            Section(header: Text("Show Title:")) {
                HStack {
                    //print(showIndex)
                    TextField("Show Title", text: $show.name)
                        .disableAutocorrection(true)
                        .font(.title)
                    if (!show.name.isEmpty) {
                        Button(action: { show.name = ""}, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
            }
            //.padding()
        
            
            Section(header: Text("Show Details:")) {
                
                 // Running
                 Toggle(isOn: $show.running, label: {
                     Text("Running?")
                 })
                 .toggleStyle(SwitchToggleStyle(tint: .blue))
                 //.padding()
                 
                
                // Show Length
                VStack(alignment: .leading) {
                    Text("Show Length:")
                    Picker("Length", selection: $show.length) {
                        ForEach(ShowLength.allCases) { length in
                            Text(length.rawValue).tag(length)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                //.padding()
                
                // Service
                HStack {
                    //Text("Service: " + show.service.rawValue)
                    //Spacer()
                    Picker("Change Service", selection: $show.service) {
                        ForEach(Service.allCases) { service in
                            Text(service.rawValue).tag(service)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .buttonStyle(.bordered)
                }
                
                // Services
                HStack {
                    Text("Select Services:")
                    Spacer()
                    Menu { // Service Filter
                        ForEach(Service.allCases) { service in
                            Button(action: {
                                if (show.services.contains(service)) {
                                    show.services = show.services.filter { $0 != service}
                                } else {
                                    show.services.append(service)
                                }
                            }) {
                                Label(service.rawValue, systemImage: show.services.contains(service) ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                        Text("Services")
                    }
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                }
                //.padding()
            }
            
            Section(header: Text("Currently Airng")) {
                HStack {
                    Toggle(isOn: $show.currentlyAiring, label: {
                        Text("Currently Airing?")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                // Airdate
                if (show.airdate != nil) {
                    HStack {
                        //Text("Airdate: " + show.airdate.rawValue)
                        //Spacer()
                        Picker("Change Airdate", selection: $show.airdate) {
                            ForEach(AirDate.allCases) { airdate in
                                Text(airdate.rawValue).tag(airdate as AirDate?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .buttonStyle(.bordered)
                    }
                    Button(action: {
                        show.airdate = nil
                    }) {
                       Text("Remove airdate")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    //.padding()
                } else {
                    Button(action: {
                        show.airdate = AirDate.Other
                    }) {
                       Text("Add airdate")
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // Limited Series
            Section(header: Text("Limited Series")) {
                HStack {
                    Toggle(isOn: $show.limitedSeries, label: {
                        Text("Limited Series?")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
            }
            
            // Seasons
            Section(header: Text("Show Seasons:")) {
                HStack {
                    Text("Total Seasons: ")
                    Spacer()
                    TextField("Total Seasons", value: $show.totalSeasons, formatter: NumberFormatter())
                        .keyboardType(UIKeyboardType.decimalPad)
                }
            }
            
            // Seasons
            Section(header: Text("Release Date:")) {
                if (show.releaseDate != nil) {
                    DatePicker(
                        "Start Date",
                        selection: $show.releaseDate.toUnwrapped(defaultValue: Date()),
                        displayedComponents: [.date]
                    )
                    Button(action: {
                        show.releaseDate = nil
                    }) {
                       Text("Remove airdate")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                } else {
                    Button(action: {
                        show.releaseDate = Date()
                    }, label: {
                        Text("Add a Release Date")
                        //.font(.title)
                    })
                    .buttonStyle(.bordered)
                }
            }
            //}
            
            ShowDetailEditActors(show: $show)
            
            
            // ID
            Section(header: Text("Internal ID:")) {
                //TextField("ID", value: $show.id, formatter: NumberFormatter())
                    //.keyboardType(.numberPad)
                Text("ID: "+show.id)
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

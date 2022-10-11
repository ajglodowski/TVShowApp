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
            
            // Shouldn't be used anymore due to functions that edit db
            /*
            Section(header: Text("Your Details:")) {
                if (show.addedToUserShows) {
                    // Rating
                    HStack {
                        if (show.rating != nil) {
                            Picker("Change Rating:", selection: $show.rating) {
                                ForEach(Rating.allCases) { rating in
                                    Text(rating.rawValue).tag(rating as Rating?)
                                }
                            }
                            //.pickerStyle(SegmentedPickerStyle())
                            .pickerStyle(MenuPickerStyle())
                            .buttonStyle(.bordered)
                        } else {
                            Button(action: {
                                show.rating = Rating.Meh
                            }) {
                                Text("Add a rating")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                    HStack {
                        Text("Current Season: ")
                        Spacer()
                        TextField("Current Season", value: $show.currentSeason, formatter: NumberFormatter())
                            .keyboardType(UIKeyboardType.decimalPad)
                    }
                    
                    // Status
                    VStack (alignment: .leading) {
                        Text("Choose a Status:")
                        ScrollView(.horizontal) {
                            HStack (alignment: .top) {
                                ForEach(Status.allCases) { status in
                                    VStack {
                                        Button(action: {
                                            switch status {
                                            case Status.ShowEnded:
                                                show.running = false
                                            case Status.CurrentlyAiring:
                                                if (show.airdate == nil) {
                                                    show.airdate = AirDate.Other
                                                }
                                            case Status.ComingSoon:
                                                if (show.releaseDate == nil) {
                                                    show.releaseDate = Date()
                                                }
                                            default:
                                                break
                                            }
                                            show.status = status
                                        }) {
                                            Text(status.rawValue)
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(status == show.status ? .blue : .gray)
                                        if (status == show.status) {
                                            Text("Current Status")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    Button(action: {
                        show.status = Status.NeedsWatched
                        show.currentSeason = 1
                    }) {
                        Text("Add to Watchlist")
                    }
                    .buttonStyle(.bordered)
                }
            }
             */
            
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
                //.padding()
            }
            
            Section(header: Text("Currently Airng")) {
                HStack {
                    Toggle(isOn: $show.currentlyAiring, label: {
                        Text("Currently Airing?")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                if (show.currentlyAiring) {
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
            if (show.releaseDate != nil || show.status == Status.ComingSoon) {
                Section(header: Text("Release Date:")) {
                    if (show.releaseDate != nil) {
                        DatePicker(
                            "Start Date",
                            selection: $show.releaseDate.toUnwrapped(defaultValue: Date()),
                            displayedComponents: [.date]
                        )
                        if (show.status != Status.ComingSoon) {
                            Button(action: {
                                show.releaseDate = nil
                            }, label: {
                                Text("Remove Release Date")
                                    .bold()
                            })
                            .buttonStyle(.bordered)
                        }
                    } else {
                        Button(action: {
                            show.status = Status.ComingSoon
                            show.releaseDate = Date()
                        }, label: {
                            Text("Add a Release Date")
                            //.font(.title)
                        })
                        .buttonStyle(.bordered)
                    }
                }
            }
            
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

//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine


struct ShowDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var show : Show
    
    @State private var isPresented = false // Edit menu var
    @State private var backgroundColor: Color = .clear
    
    var showIndex: Int {
        modelData.shows.firstIndex(where: { $0.id == show.id})!
    }
    
    var actorList: [Actor] {
        getActors(showIn: show, actors: modelData.actors)
    }
    
    init(show: Show) {
        self.show = show
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
    
        ZStack (alignment: .bottom) {
            
            backgroundColor
                .ignoresSafeArea()
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack (alignment: .center) {
                    Image(show.name)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.top, 25)
                    
                    // Text
                    VStack (alignment: .leading) {
                        HStack {
                            Text(show.name)
                                .font(.title)
                            WatchedButton(isSet: $modelData.shows[showIndex].watched)
                        }
                        
                        
                        VStack (alignment: .leading) {
                            Text("Seasons:")
                                .font(.title)
                                .padding(.top, 10)
                            ScrollView(.horizontal) {
                                HStack (alignment: .top) {
                                    ForEach(1..<show.totalSeasons+1) { num in
                                        if (num != show.currentSeason) {
                                            VStack (alignment: .center) {
                                                Button(action: {
                                                    modelData.shows[showIndex].currentSeason = num
                                                }, label: {
                                                    Text((String(num)))
                                                        .font(.title)
                                                })
                                                    .foregroundColor(Color.white)
                                                    .frame(width: 50, height: 50, alignment: .center)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.white, lineWidth: 2)
                                                    )
                                                    .padding(2)
                                            }
                                            .frame(width: 50, height: 50, alignment: .top)
                                        } else {
                                            VStack {
                                                Text(String(num))
                                                    .font(.title)
                                                    .foregroundColor(backgroundColor)
                                                    .frame(width: 50, height: 50, alignment: .center)
                                                    .background(.white)
                                                    .cornerRadius(10)
                                                Text("Current Season")
                                                    .font(.headline)
                                                    .fixedSize()
                                            }
                                            .frame(width: 50, height: 50, alignment: .top)
                                            
                                        }
                                    }
                                }
                                .padding(.bottom, 40)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            }
                        }
                        
                        HStack {
                            Text("Show Length: " + show.length.rawValue + " minutes")
                                .font(.subheadline)
                            Spacer()
                            Text(show.service.rawValue)
                                .font(.subheadline)
                        }
                        Text("Status: " + show.status.rawValue)
                            .font(.subheadline)
                        
                        if (show.status == Status.CurrentlyAiring) {
                            Text("Airdate: " + show.airdate.rawValue)
                                .font(.subheadline)
                        }
                        
                        
                        Text("Real test")
                        print(show.releaseDate)
                        /*
                        if (show.releaseDate != nil) {
                            
                            let dF = DateFormatter()
                            dF.dateFormat = "'MM'/'dd'/'yyyy'"
                            dF.dateStyle = .long
                            Text("Release Date: " + DateFormatter().string(from: show.releaseDate))
                            
                            Text("Test")
                        }
                         */
                         
                         
                        
                        Divider()
                        Text("About Show")
                    }
                    .padding()
                    // Darker, possible use in future
                    //.background(Color.secondary)
                    .background(backgroundColor.blendMode(.softLight))
                    .cornerRadius(20)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding([.leading,.trailing])
                    .foregroundColor(.white)
                    
                    // Actors Section
                    VStack(alignment: .leading){
                        Text("Actors")
                            .font(.title)
                        ForEach(actorList) { indActor in
                            NavigationLink(destination: ActorDetail(actor: indActor)) {
                                ListActorRow(actor: indActor)
                            }
                        }
                        Divider()
                        // Add a new actor
                        Button(action: {
                            var new = Actor()
                            new.shows.append(show)
                            //newShow = new
                            modelData.actors.append(new)
                            //ActorDetail(actor: new)
                        }, label: {
                            Text("Add a new Actor")
                                //.font(.title)
                        })
                        .buttonStyle(.bordered)
                        
                        //.onDelete(perform: removeRows)
                        //.background(backgroundColor.blendMode(.softLight))
                        
                    }
                    .padding()
                    // Darker, possible use in future
                    //.background(Color.secondary)
                    .background(backgroundColor.blendMode(.softLight))
                    .cornerRadius(20)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding()
                    .foregroundColor(.white)
                    
                }
            }
            .refreshable(action: {
                //show = modelData.shows[showIndex]
                
            })
        }
        
        .onAppear {
            self.setAverageColor()
        }
        
        
        .navigationTitle(show.name)
        .navigationBarTitleDisplayMode(.inline)
        //.navigationBarBackButtonHidden(false)
        
        .navigationBarItems(trailing: Button("Edit") {
                    isPresented = true
                })
        
        .sheet(isPresented: $isPresented) {
            NavigationView {
                ShowDetailEdit(isPresented: self.$isPresented, show: show, showIndex: showIndex)
                    .navigationTitle(show.name)
                    .navigationBarItems(trailing: Button("Done") {
                        isPresented = false
                    })
            }
        }
        
        /*
        .toolbar{
            NavigationLink("Edit", destination: ShowDetail(show: show))
        }
         */
    }
}
    
private func setAverageColor() {
        let uiColor = UIImage(named: show.name)?.averageColor ?? .clear
        //print(uiColor)
        backgroundColor = Color(uiColor)
    }

//.ignoresSafeArea()
}

struct ShowDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ShowDetail(show: modelData.shows[0])
                .environmentObject(modelData)
        }
    }
}

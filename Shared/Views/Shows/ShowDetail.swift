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
        modelData.shows.firstIndex(where: { $0.id == show.id })!
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
                ShowDetailEdit(isPresented: self.$isPresented, show: show)
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
        print(uiColor)
        backgroundColor = Color(uiColor)
    }

//.ignoresSafeArea()
}

struct ShowDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ShowDetail(show: modelData.shows[3])
                .environmentObject(modelData)
        }
    }
}

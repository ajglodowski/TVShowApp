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
                    // Show Picture
                    Image(show.name)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.top, 25)
                    
                    // Main Portion
                    VStack (alignment: .leading) {
                        HStack {
                            Text(show.name)
                                .font(.title)
                            WatchedButton(isSet: $modelData.shows[showIndex].watched)
                        }
                        
                        HStack {
                            if(modelData.shows[showIndex].rating != nil) { RatingRow(curRating: $modelData.shows[showIndex].rating)
                            } else {
                                Button(action: {
                                    modelData.shows[showIndex].rating = Rating.Meh
                                }) {
                                    Text("Add a rating")
                                }
                                //.background(.white)
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        HStack {
                            if (show.status != Status.UpToDate && show.status != Status.ShowEnded && show.status != Status.SeenEnough) {
                                Button(action: {
                                    modelData.shows[showIndex].status = Status.UpToDate
                                }) {
                                    Text("Up to Date")
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                                Button(action: {
                                    modelData.shows[showIndex].status = Status.ShowEnded
                                }) {
                                    Text("Show Ended")
                                }
                                .buttonStyle(.bordered)
                                .tint(.blue)
                            }
                        }
                        //.padding(5)
                        //.background(.quaternary)
                        //.cornerRadius(5)
                        
                        ShowSeasonsRow(totalSeasons: show.totalSeasons, currentSeason: $modelData.shows[showIndex].currentSeason, backgroundColor: backgroundColor, showIndex: showIndex)
                        
                        ShowDetailText(show: show, showIndex: showIndex)
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
                    ShowDetailActors(show: show, backgroundColor: backgroundColor)
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

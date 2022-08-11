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
    
    @State var showEdited: Show
    
    @State private var isPresented = false // Edit menu var
    @State private var backgroundColor: Color = .clear
    
    var showIndex: Int {
        modelData.shows.firstIndex(where: { $0.id == show.id})!
    }
    
    var addedToMyShows: Bool {
        if show.status == nil { return false }
        else { return true }
    }
    
    /*
    var actorList: [Actor] {
        getActors(showIn: show, actors: modelData.actors)
    }
     */
    
    init(show: Show) {
        self.show = show
        UINavigationBar.appearance().backgroundColor = .clear
        _showEdited = State(initialValue: show)
        //print(showEdited)
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
                        /*
                        HStack {
                            Text(show.name)
                                .font(.title)
                            WatchedButton(isSet: $modelData.shows[showIndex].watched)
                        }
                         */
                        
                        HStack {
                            if (addedToMyShows && show.rating != nil) { RatingRow(curRating: show.rating!, show: show)
                            } else if (addedToMyShows) {
                                Button(action: {
                                    updateRating(rating: Rating.Meh, showId: show.id)
                                    //modelData.shows[showIndex].rating = Rating.Meh
                                }) {
                                    Text("Add a rating")
                                }
                                //.background(.white)
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        UpdateStatusButtons(show: show)
                        
                        ShowSeasonsRow(totalSeasons: show.totalSeasons, currentSeason: $modelData.shows[showIndex].currentSeason, backgroundColor: backgroundColor, showIndex: showIndex, showId: show.id)
                        ShowDetailText(show: show, showIndex: showIndex)
                        if (addedToMyShows) {
                            Button(action: {
                                modelData.shows[showIndex].status = nil
                                modelData.shows[showIndex].rating = nil
                                modelData.shows[showIndex].currentSeason = nil
                                deleteShowFromUserShows(showId: show.id)
                            }) {
                                Text("Remove from My Shows")
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                        Divider()
                        TagsSection(showId: show.id, activeTags: show.tags!)
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
                ShowDetailEdit(isPresented: self.$isPresented, show: $showEdited)
                    .navigationTitle(show.name)
                    .navigationBarItems(leading: Button("Cancel") {
                        showEdited = show
                        isPresented = false
                    }, trailing: Button("Done") {
                        //print(showEdited)
                        if (showEdited != show) {
                            addOrUpdateToUserShows(show: showEdited)
                            if (showEdited.name != show.name) {
                                updateToShows(show: showEdited, showNameEdited: true)
                            } else {
                                updateToShows(show: showEdited, showNameEdited: false)
                            }
                        }
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

//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine
import Firebase

struct ShowDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var photoVm = ShowDetailPhotoViewModel()
    @ObservedObject var showVm = ShowDetailViewModel()
    
    var showId: String
    
    var show : Show? {
        if (modelData.shows.contains(where: { $0.id == showId})) {
            return modelData.shows.first(where: { $0.id == showId})
        } else {
            // Load show
            showVm.loadShow(id: showId)
            return showVm.show
        }
    }
    
    //@State var showEdited: Show
    
    @State private var isPresented = false // Edit menu var
    private var backgroundColor: Color {
        if (photoVm.showImage != nil) {
            return Color(photoVm.showImage?.averageColor ?? .black)
        } else {
            return Color.black
        }
    }
    
    var showIndex: Int {
        if (show != nil) {
            return modelData.shows.firstIndex(where: { $0.id == show!.id})!
        } else {
           return  -1
        }
    }
    
    var addedToMyShows: Bool {
        if (show != nil && show!.status == nil) { return false }
        else { return true }
    }
    
    /*
    var actorList: [Actor] {
        getActors(showIn: show, actors: modelData.actors)
    }
     */
    
    init(showId: String) {
        //self.show = show
        self.showId = showId
        
        UINavigationBar.appearance().backgroundColor = .clear
        //_showEdited = State(initialValue: show ?? Show(id:"1"))
        //print(showEdited)
    }
    
    var body: some View {
        
        VStack {
            
            if (show != nil) {
                
                ZStack (alignment: .bottom) {
                    
                    backgroundColor
                        .ignoresSafeArea()
                    
                    GeometryReader { geometry in
                        ScrollView {
                            VStack (alignment: .center) {
                                // Show Picture
                                if (photoVm.showImage != nil) {
                                    Image(uiImage: photoVm.showImage!)
                                        .resizable()
                                        .scaledToFit()
                                        .clipped()
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                                        .cornerRadius(20)
                                        .shadow(radius: 10)
                                        .padding(.top, 25)
                                } else {
                                    Image(systemName : "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .clipped()
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                                        .cornerRadius(20)
                                        .shadow(radius: 10)
                                        .padding(.top, 25)
                                }
                                
                                
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
                                        if (addedToMyShows && show!.rating != nil) { RatingRow(curRating: show!.rating!, show: show!)
                                        } else if (addedToMyShows) {
                                            Button(action: {
                                                updateRating(rating: Rating.Meh, showId: show!.id)
                                                incrementRatingCount(showId: show!.id, rating: Rating.Meh)
                                            }) {
                                                Text("Add a rating")
                                            }
                                            //.background(.white)
                                            .buttonStyle(.bordered)
                                        }
                                    }
                                    
                                    UpdateStatusButtons(show: show!)
                                    
                                    ShowSeasonsRow(totalSeasons: show!.totalSeasons, currentSeason: show!.currentSeason, backgroundColor: backgroundColor, showId: show!.id)
                                    ShowDetailText(show: show!, showIndex: showIndex)
                                    if (addedToMyShows) {
                                        Button(action: {
                                            modelData.shows[showIndex].status = nil
                                            modelData.shows[showIndex].rating = nil
                                            modelData.shows[showIndex].currentSeason = nil
                                            deleteShowFromUserShows(showId: show!.id)
                                            decrementShowCount(userId: Auth.auth().currentUser!.uid)
                                        }) {
                                            Text("Remove from My Shows")
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(.red)
                                    }
                                    Divider()
                                    TagsSection(showId: show!.id, activeTags: show!.tags!)
                                }
                                .padding()
                                // Darker, possible use in future
                                //.background(Color.secondary)
                                .background(backgroundColor.blendMode(.softLight))
                                .cornerRadius(20)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .padding([.leading,.trailing])
                                .foregroundColor(.white)
                                
                                ShowRatingsGraph(show: show!, backgroundColor: backgroundColor)
                                
                                // Actors Section
                                ShowDetailActors(show: show!, backgroundColor: backgroundColor)
                            }
                        }
                        .ignoresSafeArea(edges: .horizontal)
                    }
                }
            } else {
                Text("Loading Show")
            }
        }
        .task {
            photoVm.loadImage(showName: show!.name)
        }
        .refreshable {
            photoVm.loadImage(showName: show!.name)
        }
        
        // Top bar
        .navigationTitle(show?.name ?? "Loading Show")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (show != nil) {
                    Button("Edit") {
                        isPresented = true
                    }
                }
            }
        }
        
        /*
        .sheet(isPresented: $isPresented) {
            NavigationView {
                if (showEdited != nil) {
                    ShowDetailEdit(isPresented: self.$isPresented, show: $showEdited)
                        .navigationTitle(show?.name ?? "Loading Show")
                        .navigationBarItems(leading: Button("Cancel") {
                            showEdited = show!
                            isPresented = false
                        }, trailing: Button("Done") {
                            //print(showEdited)
                            if (showEdited != show) {
                                addOrUpdateToUserShows(show: showEdited)
                                if (showEdited.name != show!.name) {
                                    updateToShows(show: showEdited, showNameEdited: true)
                                } else {
                                    updateToShows(show: showEdited, showNameEdited: false)
                                }
                            }
                            //print(isPresented)
                            isPresented = false
                            //print(isPresented)
                        })
                }
            }
        }
         */
        
        /*
        .toolbar{
            NavigationLink("Edit", destination: ShowDetail(show: show))
        }
         */
    }
}
    
    /*
private func setAverageColor() {
    let uiColor = photoVm.showImage?.averageColor ?? .black
        //print(uiColor)
        backgroundColor = Color(uiColor)
    }
     */


struct ShowDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ShowDetail(showId: "SEAXF5uqtqS3rbRhOU4S")
                .environmentObject(modelData)
        }
    }
}

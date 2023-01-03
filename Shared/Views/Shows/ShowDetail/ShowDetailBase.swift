//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine
import Firebase

struct ShowDetailBase: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var photoVm = ShowDetailPhotoViewModel()
    //@ObservedObject var showVm = ShowDetailViewModel()
    
    //var showId: String
    
    var show : Show?
    
    var photo: UIImage? { photoVm.showImage }
    
    @State var showEdited: Show = Show(id:"1")
    
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
    
    init(show: Show? = nil) {
        self.show = show
        UINavigationBar.appearance().backgroundColor = .clear
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
                                if (photo != nil) {
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
                                    
                                    HStack {
                                        if (addedToMyShows && show!.rating != nil) { RatingRow(curRating: show!.rating!, show: show!)
                                        } else if (addedToMyShows) {
                                            Button(action: {
                                                updateRating(rating: Rating.Meh, showId: show!.id)
                                                incrementRatingCount(showId: show!.id, rating: Rating.Meh)
                                                Task {
                                                    //await reloadData()
                                                }
                                            }) {
                                                Text("Add a rating")
                                            }
                                            //.background(.white)
                                            .buttonStyle(.bordered)
                                        }
                                    }
                                    
                                    UpdateStatusButtons(show: show!)
                                    
                                    ShowSeasonsRow(totalSeasons: show!.totalSeasons, currentSeason: show!.currentSeason, backgroundColor: backgroundColor, showId: show!.id)
                                    ShowDetailText(show: show!)
                                    if (addedToMyShows) {
                                        Button(action: {
                                            modelData.shows[showIndex].status = nil
                                            modelData.shows[showIndex].rating = nil
                                            modelData.shows[showIndex].currentSeason = nil
                                            deleteShowFromUserShows(showId: show!.id)
                                            addUserUpdateRemove(userId: Auth.auth().currentUser!.uid, show: show!)
                                            decrementShowCount(userId: Auth.auth().currentUser!.uid)
                                            Task {
                                                //await reloadData()
                                            }
                                        }) {
                                            Text("Remove from My Shows")
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(.red)
                                    }
                                    Divider()
                                    UpdateLogSection(show: show!)
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
                                ShowStatusGraph(show: show!, backgroundColor: backgroundColor)
                                
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
            if (show != nil) { photoVm.loadImage(showName: show!.name) }
        }
        .refreshable {
            if (show != nil) { photoVm.loadImage(showName: show!.name) }
        }
        
        // Top bar
        .navigationTitle(show?.name ?? "Loading Show")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (show != nil) {
                    Button("Edit") {
                        showEdited = show!
                        isPresented = true
                    }
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                if (showEdited.id != "1") {
                    ShowDetailEdit(isPresented: self.$isPresented, show: $showEdited)
                        .navigationTitle(show?.name ?? "Loading Show")
                        .navigationBarItems(leading: Button("Cancel") {
                            showEdited = show!
                            isPresented = false
                        }, trailing: Button("Done") {
                            if (showEdited != show) {
                                //addOrUpdateToUserShows(show: showEdited)
                                if (showEdited.name != show!.name) {
                                    updateToShows(show: showEdited, showNameEdited: true)
                                } else {
                                    updateToShows(show: showEdited, showNameEdited: false)
                                }
                            }
                            isPresented = false
                            Task {
                                //await reloadData()
                            }
                        })
                } else {
                    Text("Error loading show")
                }
            }
        }
    }
}
    
    /*
private func setAverageColor() {
    let uiColor = photoVm.showImage?.averageColor ?? .black
        //print(uiColor)
        backgroundColor = Color(uiColor)
    }
     */


//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine
import Firebase
import SkeletonUI

struct ShowDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var photoVm = ShowDetailPhotoViewModel()
    @ObservedObject var showVm = ShowDetailViewModel()
    
    var show : Show? { modelData.showDict[showId] }
    var showId: String
    
    //var photo: UIImage? { photoVm.showImage }
    var photo: UIImage? { modelData.fullShowImages[show?.id ?? "-1"] }
    
    @State var showEdited: Show = Show(id:"1")
    
    @State private var isPresented = false // Edit menu var
    private var backgroundColor: Color {
        if (photo != nil) { return Color(photo?.averageColor ?? .black) }
        else { return Color.black }
    }
    
    init(showId: String) {
        self.showId = showId
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
                                Image(uiImage: photo)
                                    .resizable()
                                    .skeleton(with: photo == nil)
                                    .shape(type: .rectangle)
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .padding(.top, 25)
                                
                                
                                // Main Portion
                                VStack (alignment: .leading) {
                                    
                                    HStack {
                                        if (show!.addedToUserShows && show!.userSpecificValues!.rating != nil) { RatingRow(curRating: show!.userSpecificValues!.rating!, show: show!)
                                        } else if (show!.addedToUserShows) {
                                            Button(action: {
                                                updateRating(rating: Rating.Meh, showId: show!.id)
                                                addUserUpdateRatingChange(userId: Auth.auth().currentUser!.uid, show: show!, rating: Rating.Meh)
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
                                    
                                    ShowSeasonsRow(totalSeasons: show!.totalSeasons, currentSeason: show!.userSpecificValues?.currentSeason ?? nil, backgroundColor: backgroundColor, showId: show!.id)
                                    ShowDetailText(show: show!)
                                    if (show!.addedToUserShows) {
                                        Button(action: {
                                            //modelData.shows[showIndex].status = nil
                                            //modelData.shows[showIndex].rating = nil
                                            //modelData.shows[showIndex].currentSeason = nil
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
            if (modelData.showDict[showId] == nil) { showVm.loadShow(modelData: modelData, id: showId) }
            if (show != nil) { photoVm.loadImage(modelData: modelData, show: show!) }
        }
        .refreshable {
            showVm.loadShow(modelData: modelData, id: showId)
            if (show != nil) { photoVm.loadImage(modelData: modelData, show: show!) }
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
                ShowDetailEdit(isPresented: self.$isPresented, show: $showEdited)
                    .navigationTitle(show?.name ?? "Loading Show")
                    .navigationBarItems(leading: Button("Cancel") {
                        showEdited = show!
                        isPresented = false
                    }, trailing: Button("Done") {
                        if (showEdited != show) {
                            showEdited.lastUpdated = Date()
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


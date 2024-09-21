//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine
import SkeletonUI

struct ShowDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var photoVm = ShowDetailPhotoViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    var show : Show? { modelData.showDict[showId] }
    var showId: Int
    var uid: String? { modelData.currentUser?.id }
    
    var photo: UIImage? { photoVm.showImage }
    //var photo: UIImage? { modelData.fullShowImages[show?.id ?? -1] }
    
    @State var showEdited: Show = Show(id:-1)
    
    @State private var isPresented = false // Edit menu var
    private var backgroundColor: Color {
        if (photo != nil) { return Color(photo?.averageColor ?? .black) }
        else { return Color.black }
    }
    
    init(showId: Int) {
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
                                ShowDetailImage(photo: photo, showName: show!.name, geometry: geometry)
                                
                                // Main Portion
                                VStack (alignment: .leading) {
                                    
                                    RatingSection(show: show!)
                                    
                                    UpdateStatusButtons(showId: show!.id)
                                    
                                    ShowSeasonsRow(backgroundColor: backgroundColor, showId: show!.id)
                                    ShowDetailText(show: show!)
                                    if (show!.addedToUserShows) {
                                        Button(action: {
                                            //deleteShowFromUserShows(showId: show!.id)
                                            //addUserUpdateRemove(userId: Auth.auth().currentUser!.uid, show: show!)
                                            //decrementShowCount(userId: Auth.auth().currentUser!.uid)
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
                                    TagsSection(showId: show!.id)
                                }
                                .padding()
                                // Darker, possible use in future
                                //.background(Color.secondary)
                                .background(backgroundColor.blendMode(.softLight))
                                .cornerRadius(20)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .padding([.leading,.trailing])
                                .foregroundColor(.white)
                                
                                ShowRatingsGraph(backgroundColor: backgroundColor, showId: show!.id)
                                ShowStatusGraph(backgroundColor: backgroundColor, showId: show!.id)
                                
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
        }
        .task(id: show) {
            if (show != nil) {
                await photoVm.loadImage(showName: show!.name)
            }
        }
        .refreshable {
            await modelData.reloadAllShowData(showId: showId, userId: uid)
            if (show != nil) {
                await photoVm.loadImage(showName: show!.name)
            }
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
                            Task {
                                let updatedShow = SupabaseShow(from: showEdited)
                                let success = await updateShow(show: updatedShow)
                                if (success) {
                                    await modelData.reloadAllShowData(showId: showId, userId: uid)
                                    isPresented = false
                                }
                            }
                        }
                    })
            }
        }
    }
}

struct ShowDetailImage: View {
    
    var photo: UIImage?
    var showName: String
    var geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Image(uiImage: photo)
                .resizable()
                .skeleton(with: photo == nil, shape: .rectangle)
                .scaledToFit()
                .clipped()
                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 25)
                .overlay(alignment: .bottom) {
                    Text(showName)
                        .font(.system(size: UIFont.textStyleSize(.largeTitle) * 1.5, weight: .heavy))
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .offset(y: 50)
                }
                .padding(.bottom, 50)
        }
    }
}

#Preview {
    return ShowDetail(showId: 100)
        .environmentObject(ModelData())
}
 
public extension UIFont {
  static func textStyleSize(_ style: UIFont.TextStyle) -> CGFloat {
      UIFont.preferredFont(forTextStyle: style).pointSize
  }
}

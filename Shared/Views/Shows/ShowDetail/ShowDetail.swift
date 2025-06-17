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
    
    @State var showEdited: Show = Show(id:-1)
    @State private var isPresented = false // Edit menu var
    @State private var selectedTab = "show-info"
    
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
            if let show = show {
                ZStack(alignment: .bottom) {
                    backgroundColor.ignoresSafeArea()
                    
                    ShowDetailContent(
                        show: show,
                        photo: photo,
                        backgroundColor: backgroundColor,
                        selectedTab: $selectedTab
                    )
                }
            } else {
                Text("Loading Show")
            }
        }
        .task {
            if (modelData.showDict[showId] == nil) { 
                showVm.loadShow(modelData: modelData, id: showId) 
            }
        }
        .task(id: show) {
            if let show = show {
                if (show.pictureUrl != nil) {
                    await photoVm.loadImage(pictureUrl: show.pictureUrl!)
                }
            }
        }
        .refreshable {
            await modelData.reloadAllShowData(showId: showId, userId: uid)
            if let show = show {
                if (show.pictureUrl != nil) {
                    await photoVm.loadImage(pictureUrl: show.pictureUrl!)
                }
            }
        }
        .navigationTitle(show?.name ?? "Loading Show")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if show != nil {
                    Button(action: {
                        showEdited = show!
                        isPresented = true
                    }) {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .showDetailEditSheet(
            show: show,
            showId: showId,
            uid: uid,
            isPresented: $isPresented,
            showEdited: $showEdited
        )
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
            
            Text(showName)
                .font(.system(size: UIFont.textStyleSize(.largeTitle) * 1.5, weight: .heavy))
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 16)
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

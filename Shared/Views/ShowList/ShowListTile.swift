//
//  ShowListTile.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/23/22.
//

import SwiftUI
import SkeletonUI

struct ShowListTile: View {

    @StateObject var listVm = ShowListViewModel()
    @EnvironmentObject var modelData : ModelData
    
    var showListId: Int
    
    var showListObj: ShowList? { listVm.showListObj }
    var listLoaded: Bool { showListObj != nil }
    var currentUserId: String? { modelData.currentUser?.id }
    
    var visable: Bool {
        var out = true
        if (showListObj != nil && (showListObj!.priv && showListObj!.creator == currentUserId)) {
            out = false
        }
        return out
    }
    
    /* TODO
    var likedByCurrentUser: Bool {
        if (showListObj != nil &&
            modelData.currentUser != nil &&
            modelData.currentUser!.likedShowLists != nil &&
            modelData.currentUser!.likedShowLists!.contains(where: { $0 == showListObj!.id })) {
            return true
        } else {
            return false
        }
    }
     */
    
    
    
    var listShows: [Show] { showListObj?.shows.map { $0.show } ?? [] }
    
    var body: some View {
        VStack {
            if (visable) {
                NavigationLink(destination: ShowListDetail(listId: showListId)) {
                    VStack(alignment: .leading) {
                        if (!listLoaded) {
                            Text("Loading")
                        } else {
                            let listObj = showListObj!
                            VStack { // Image section
                                ZStack(alignment: .leading) {
                                    ForEach(Array(listShows.enumerated()), id: \.offset) { loopInd, show in
                                        ShowSquareTile(show: show, titleShown: false)
                                            .offset(x: (CGFloat(loopInd) * 30) - 5.0)
                                            .zIndex(Double(listShows.count - loopInd))
                                    }
                                }
                                .frame(width: 250, height: 150, alignment: .leading)
                            }
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("\(listObj.name)")
                                        .font(.headline)
                                    if (listObj.priv) {
                                        Text("Private")
                                            .padding(5)
                                            .background(.tertiary)
                                            .cornerRadius(5)
                                    }
                                }
                                .frame(height: 25)
                                Text("\(listObj.description)")
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                HStack {
                                    ProfileBubble(profileId: listObj.creator)
                                    Spacer()
                                    /*
                                     if (likedByCurrentUser) {
                                     Text("Liked")
                                     Image(systemName: "heart.fill")
                                     .tint(.pink)
                                     }
                                     Text("\(listObj.likeCount) likes")
                                     */
                                }
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .frame(width: 250, height: 100)
                        }
                    }
                    .skeleton(with: !listLoaded)
                    .frame(width: 250, height: 250)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .task {
            await listVm.loadList(id: showListId, showLimit: 5)
        }
        .background(.quaternary)
        .cornerRadius(20)
    }
}

#Preview {
    ShowListTile(showListId: 1)
        .environmentObject(ModelData())
}

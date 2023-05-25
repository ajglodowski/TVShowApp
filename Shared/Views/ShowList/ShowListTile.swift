//
//  ShowListTile.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/23/22.
//

import SwiftUI

struct ShowListTile: View {
    
    @StateObject var listVm = ShowListViewModel()
    @EnvironmentObject var modelData : ModelData
    
    var showListId: String
    
    @State var showListObj: ShowList? = nil
    
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
    
    var listShows: [Show] {
        var output = [Show]()
        if (showListObj == nil) { return output }
        showListObj!.shows.forEach { show in
            if (modelData.showDict[show] != nil) {
                output.append(modelData.showDict[show]!)
            }
        }
        return output
    }
    
    var body: some View {
        VStack {
            if (showListObj != nil && (!showListObj!.priv || showListObj!.profile.id == modelData.currentUser?.id)) {
                let listObj = showListObj!
                NavigationLink(destination: ShowListDetail(listId: listObj.id)) {
                    VStack(alignment: .leading) {
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
                                ProfileBubble(profileId: listObj.profile.id)
                                Spacer()
                                if (likedByCurrentUser) {
                                    Text("Liked")
                                    Image(systemName: "heart.fill")
                                        .tint(.pink)
                                }
                                Text("\(listObj.likeCount) likes")
                            }
                            
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    }
                    .frame(width: 250)
                }
            }
        }
        .task {
            await listVm.loadList(modelData: modelData, id: showListId, showLimit: 5)
            self.showListObj = listVm.showListObj
        }
        .background(.quaternary)
        .cornerRadius(20)
    }
}

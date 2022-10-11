//
//  ShowListTile.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/23/22.
//

import SwiftUI

struct ShowListTile: View {
    
    @StateObject var listVm = ShowListViewModel()
    @ObservedObject var modelData = ModelData()
    
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
    
    var body: some View {
        VStack {
            if (showListObj != nil) {
                let listObj = showListObj!
                NavigationLink(destination: ShowListDetail(listId: listObj.id)) {
                    VStack(alignment: .leading) {
                        VStack { // Image section
                            ZStack {
                                ForEach(Array(listObj.shows.enumerated()), id: \.offset) { loopInd, show in
                                    ShowSquareTile(show: show, titleShown: false)
                                        .offset(x: CGFloat(loopInd) * 30)
                                        .zIndex(Double(listObj.shows.count - loopInd))
                                }
                            }
                            .frame(width: 250, alignment: .leading)
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
                            Text("\(listObj.description)")
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            HStack {
                                NavigationLink(destination: ProfileDetail(id: listObj.profile.id)) {
                                    Text("@\(listObj.profile.username)")
                                        .italic()
                                        //.padding(5)
                                        //.background(.tertiary)
                                        //.cornerRadius(5)
                                }
                                .buttonStyle(.bordered)
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
            listVm.fillInLoadedShows(shows: modelData.shows)
            await listVm.loadList(id: showListId, showLimit: 5)
            self.showListObj = listVm.showListObj
        }
        .background(.quaternary)
        .cornerRadius(20)
    }
}

//
//  ShowListLikeSection.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/25/24.
//

import SwiftUI

struct ShowListLikeSection: View {
    
    /*
    var likedByCurrentUser: Bool {
        if (listObj != nil &&
            modelData.currentUser != nil &&
            modelData.currentUser!.likedShowLists != nil &&
            modelData.currentUser!.likedShowLists!.contains(listObj!.id)) {
            return true
        } else {
            return false
        }
    }
     */
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        /*
        HStack {
            Text("\(listObj!.likeCount) likes")
            Button(action: {
                if (likedByCurrentUser) {
                    //dislikeList(listId: listObj!.id)
                    Task {
                        await reloadData()
                    }
                } else {
                    //likeList(listId: listObj!.id)
                    Task {
                        await reloadData()
                    }
                }
            }) {
                if (likedByCurrentUser) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: "heart")
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                }
            }
            .buttonStyle(.plain)
        }
        */
    }
}

#Preview {
    ShowListLikeSection()
}

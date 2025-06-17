//
//  SquareTileScrollRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI
import SkeletonUI

enum ScrollRowType {
    case NoExtraText
    case Airdate
    case ComingSoon
    case StatusDisplayed
}


struct SquareTileScrollRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var uid: String? { modelData.currentUser?.id }
    
    var items: [Show]
    
    var scrollType: ScrollRowType
    
    func isOutNow(s: Show) -> Bool {
        if (s.addedToUserShows && s.userSpecificValues!.status.id == ComingSoonStatusId) {
            if ((s.releaseDate != nil) && (s.releaseDate! < Date.now)) { return true }
        }
        return false
    }
    
    var tileType: ShowTileType {
        if (scrollType == .ComingSoon) { return .ComingSoon }
        return .Default
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { show in
                        VStack {
                            NavigationLink(destination: ShowDetail(showId: show.id)) {
                                ShowSquareTile(show: show, titleShown: true, tileType: tileType)
                            }
                            .foregroundColor(.primary)
                            if (scrollType == ScrollRowType.ComingSoon && isOutNow(s: show) ) {
                                Button(action: {
                                    Task {
                                        if (uid != nil) {
                                            let success = await updateUserShowData(updateType: UserUpdateCategory.UpdatedStatus, userId: uid!, showId: show.id, seasonChange: nil, ratingChange: nil, statusChange: Status.init(id: CurrentlyAiringStatusId, name: "Currently Airing", created_at: Date(), update_at: Date()))
                                            if (success) {
                                                await modelData.reloadAllShowData(showId: show.id, userId: uid)
                                            }
                                        }
                                    }
                                }) {
                                    Text("Add to \n Currently Airing")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                    }
                }
                //.padding(.horizontal, 5)
            }
        }
    }
}

struct SquareTileScrollRowLoading: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(0..<4) { _ in
                    ShowSquareTileLoading()
                }
            }
        }
    }
}

#Preview("Loading View") {
    SquareTileScrollRowLoading()
}

//
//struct SquareTileScrollRow_Previews: PreviewProvider {
//    
//    static var shows = ModelData().shows
//    
//    static var previews: some View {
//        ScrollView {
//            VStack {
//                SquareTileScrollRow(items: shows, scrollType: ScrollRowType.NoExtraText)
//                SquareTileScrollRow(items: shows, scrollType: ScrollRowType.Airdate)
//                SquareTileScrollRow(items: shows.filter {$0.addedToUserShows && $0.userSpecificValues!.status.id == ComingSoonStatusId}, scrollType: ScrollRowType.ComingSoon)
//                SquareTileScrollRowLoading()
//            }
//        }
//    }
//}

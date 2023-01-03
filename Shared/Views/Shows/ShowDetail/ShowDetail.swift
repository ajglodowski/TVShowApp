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
    
    @ObservedObject var showVm = ShowDetailViewModel()
    @ObservedObject var photoVm = ShowDetailPhotoViewModel()
    
    var showId: String
    
    var loadedShow: Show? { showVm.show }
    
    var body: some View {
        VStack {
            if (modelData.shows.contains(where: { $0.id == showId })) {
                ShowDetailBase(show: modelData.shows.first(where: { $0.id == showId }))
            } else {
                ShowDetailBase(show: loadedShow)
            }
        }
        .task {
            showVm.loadShow(id: showId)
        }
    }
    
}

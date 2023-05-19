//
//  UserUpdateDetailRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/9/23.
//

import SwiftUI

struct UserUpdateDetailRow: View {
    
    let update: UserUpdate
    let userShown: Bool
    
    @EnvironmentObject var modelData : ModelData
    @StateObject var vm = ShowTileViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    var show: Show? { modelData.showDict[update.showId] }
    
    var dateString: String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        df.dateStyle = .short
        df.timeStyle = .short
        let str = df.string(from: update.updateDate)
        return str.replacingOccurrences(of: ",", with: "")
    }
    
    var body: some View {
        VStack {
            HStack (alignment: .center, spacing: 0) {
                VStack {
                    if (vm.showImage != nil) {
                        Image(uiImage: vm.showImage!)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    } else {
                        LoadingView()
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.horizontal, 2)
                VStack (alignment: .leading, spacing: 0) {
                    if (show != nil) {
                        Text(show!.name)
                            .bold()
                    } else {
                        Text("Loading Show")
                    }
                    Text(update.updateMessage)
                        .font(.callout.leading(.tight))
                    Text(dateString)
                        .font(.footnote)
                    if (userShown) { ProfileBubble(profileId: update.userId) }
                }
                //.multilineTextAlignment(.leading)
            }
        }
        .task {
            if (show == nil) { showVm.loadShow(modelData: modelData, id: update.showId) }
        }
        .task(id: show?.name ?? nil) {
            if (show != nil) { vm.loadImage(showName: show!.name) }
        }
    }
}

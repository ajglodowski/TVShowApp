//
//  UserUpdateCard.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/1/23.
//

import SwiftUI

struct UserUpdateCard: View {
    
    @EnvironmentObject var modelData : ModelData
    @StateObject var vm = ShowTileViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    var update: UserUpdate
    
    var show: Show? {
        if (modelData.showDict[update.showId] != nil) { return modelData.showDict[update.showId] }
        else { return showVm.show }
    }
    
    var dateString: String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        df.dateStyle = .short
        df.timeStyle = .short
        let str = df.string(from: update.updateDate)
        return str.replacingOccurrences(of: ",", with: "")
    }
    
    private var backgroundColor: Color {
        if (vm.showImage != nil) { return Color(vm.showImage?.averageColor ?? .black) }
        else { return Color.black }
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
                            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    } else {
                        Image(systemName : "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
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
                    ProfileBubble(profileId: update.userId)
                }
                .multilineTextAlignment(.leading)
                //.padding(.vertical, 1)
                .padding(.horizontal, 4)
                .frame(width: 150, height: 100, alignment: .leading)
            }
        }
        .background(backgroundColor)
        .cornerRadius(15)
        .task {
            if (show == nil) { showVm.loadShow(id: update.showId) }
        }
        .task(id: show?.name ?? nil) {
            if (show != nil) { vm.loadImage(showName: show!.name) }
        }
    }
    
}

//
//  UserUpdateCard.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/1/23.
//

import SwiftUI
import SkeletonUI

struct UserUpdateCard: View {
    
    @EnvironmentObject var modelData : ModelData
    @StateObject var vm = ShowTileViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    var update: UserUpdate
    
    var show: Show? { modelData.showDict[update.showId] }
    
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
        else { return Color(.quaternaryLabel) }
    }
    
    var imageLoaded: Bool { vm.showImage != nil }
    
    var body: some View {
        VStack {
            HStack (alignment: .center, spacing: 0) {
                VStack {
                    Image(uiImage: vm.showImage)
                        .resizable()
                        .skeleton(with: !imageLoaded, shape: .rectangle)
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                VStack (alignment: .leading, spacing: 0) {
                    Text(show?.name)
                        .skeleton(with: (show == nil))
                        .bold()
                    Text(update.updateMessage)
                        .skeleton(with: (show == nil))
                        .font(.callout.leading(.tight))
                    Text(dateString)
                        .skeleton(with: (show == nil))
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
            if (show == nil) { showVm.loadShow(modelData: modelData, id: update.showId) }
        }
        .task(id: show?.name ?? nil) {
            if (show != nil) { await vm.loadImage(showName: show!.name) }
        }
    }
    
}

#Preview {
    let update = UserUpdate(from: MockSupabasUserUpdate)
    return UserUpdateCard(update: update)
        .environmentObject(ModelData())
}



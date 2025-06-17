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
        ZStack(alignment: .bottom) {
            // Image container
            Group {
                Image(uiImage: vm.showImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .skeleton(with: vm.showImage == nil,  shape: .rectangle)
                    .frame(width: 200, height: 200)
                    .cornerRadius(15)
            }
            
            // Content overlay with blur
            VStack(alignment: .leading, spacing: 2) {
                Text(show?.name ?? "Loading Show...")
                    .font(.system(size: 14, weight: .medium))
                    .skeleton(with: show == nil, size: CGSize(width: 100, height: 14))
                    .lineLimit(1)
                
                Text(update.updateMessage)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.7))
                    .skeleton(with: show == nil, size: CGSize(width: 150, height: 12))
                    .lineLimit(1)
                
                Text(dateString)
                    .font(.system(size: 10))
                    .foregroundColor(Color.white.opacity(0.6))
                    .skeleton(with: show == nil, size: CGSize(width: 80, height: 10))
                
                ProfileBubble(profileId: update.userId)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .thinMaterial
            )
            .cornerRadius(15)
            .clipped()
        }
        .frame(width: 200, height: 200)
        .shadow(radius: 2)
        .task {
            if show == nil {
                await showVm.loadShow(modelData: modelData, id: update.showId)
            }
        }
        .task(id: show?.pictureUrl) {
            if let url = show?.pictureUrl, vm.showImage == nil {
                await vm.loadImage(pictureUrl: url)
            }
        }
    }
}

struct UserUpdateCardLoading: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Image container
            Rectangle()
                .skeleton(with: true, shape: .rectangle)
                .frame(width: 200, height: 200)
                .cornerRadius(15)
            
            // Content overlay with blur
            VStack(alignment: .leading, spacing: 2) {
                Text("")
                    .font(.system(size: 14, weight: .medium))
                    .skeleton(with: true, size: CGSize(width: 100, height: 14))
                    .lineLimit(1)
                
                Text("")
                    .font(.system(size: 12))
                    .skeleton(with: true, size: CGSize(width: 150, height: 12))
                    .lineLimit(1)
                
                Text("")
                    .font(.system(size: 10))
                    .skeleton(with: true, size: CGSize(width: 80, height: 10))
                
                ProfileBubbleLoading()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .ultraThinMaterial
            )
            .cornerRadius(15)
            .clipped()
        }
        .frame(width: 200, height: 200)
        .shadow(radius: 2)
    }
}

#Preview("Loading UserUpdateCard") {
    UserUpdateCardLoading()
}

#Preview {
    let update = UserUpdate(from: MockSupabasUserUpdate)
    let modelData = ModelData()
    return UserUpdateCard(update: update)
        .environmentObject(modelData)
        .padding()
        .previewLayout(.sizeThatFits)
}



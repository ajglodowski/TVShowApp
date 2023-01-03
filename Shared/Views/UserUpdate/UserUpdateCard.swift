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
    @StateObject var prof = ProfileViewModel()
    
    var profile: Profile? { prof.profile }
    var profilePic: Image? { prof.profilePic }
    
    var update: UserUpdate
    
    var show: Show? {
        modelData.shows.first(where: { $0.id == update.showId})
    }
    
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
                        Text("Show with this id cannot be found")
                    }
                    Text(update.updateMessage)
                        .font(.callout)
                    Text(dateString)
                        .font(.footnote)
                    userSection
                }
                .multilineTextAlignment(.leading)
                //.padding(.vertical, 1)
                .padding(.horizontal, 1)
                .frame(width: 150, height: 100)
            }
        }
        .background(.tertiary)
        .cornerRadius(15)
        .task {
            prof.loadProfile(id: update.userId)
            vm.loadImage(showName: show!.name)
        }
    }
    
    var userSection: some View {
        HStack {
            if (profile == nil || profilePic == nil) { Text("Loading Profile") }
            else {
                NavigationLink(destination: ProfileDetail(id: profile!.id)) {
                    HStack {
                        profilePic!
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                        Text(profile!.username)
                            .font(.callout)
                    }
                    .padding(-5)
                    .padding(.leading, -7)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .foregroundColor(.primary)
                .padding(-1)
            }
        }
        
    }
    
    
    
    
}

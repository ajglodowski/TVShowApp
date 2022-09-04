//
//  ProfileDetail.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/4/22.
//

import SwiftUI

struct ProfileDetail: View {
    
    @ObservedObject var modelData = ModelData()
    
    @StateObject var prof = ProfileViewModel()
    @StateObject var showVm = ShowDetailViewModel()
    
    let id: String
    
    var body: some View {
        
        VStack {
            
            var profile: Profile? = prof.profile
            var profilePic: Image? = prof.profilePic
            
            if (profile != nil) {
                VStack (alignment: .leading) {
                    HStack {
                        VStack {
                            if (profilePic != nil) {
                                VStack {
                                    profilePic!
                                        .resizable()
                                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        .scaledToFit()
                                }
                                .frame(width: 175, height: 175, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            } else {
                                Text("Loading Profile Picture")
                            }
                        }
                        .padding()
                        VStack (alignment: .leading) {
                            Text("@\(profile!.username)")
                                .font(.title)
                                .italic()
                                .bold()
                            Text("\(profile!.bio)")
                            Text("\(profile!.showCount) shows logged")
                                .bold()
                        }
                        .padding()
                    }
                    VStack(alignment: .leading) {
                        if (!profile!.lovedShows.isEmpty) {
                            Text("\(profile!.username)'s Loved Shows:")
                                .font(.headline)
                            ScrollView(.horizontal) {
                                ForEach(profile!.lovedShows) { show in
                                    ShowTile(showName: show.name)
                                    /*
                                    if (modelData.shows.contains(where: { $0.id == show.id})) {
                                        ShowTile(showName: show.name)
                                    } else {
                                        showVm.loadShow(id: <#T##String#>)
                                    }
                                     */
                                }
                            }
                        } else {
                            Text("This user hasn't loved any shows 😔")
                                .font(.headline)
                        }
                    }
                }
                .padding()
            } else {
                Text("Loading Profile")
            }
            
        }
        /*
        .refreshable {
            if (!current) { await rm.fetchAll(year: year!, round: round!, current: false) }
            else { await rm.fetchAll(year: "", round: "", current: true) }
        }
         */
        .task {
            prof.loadProfile(id: id)
        }
    }
    
    
}
/*
 struct ProfileDetail_Previews: PreviewProvider {
 static var previews: some View {
 ProfileDetail()
 }
 }
 */

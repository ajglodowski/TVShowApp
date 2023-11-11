//
//  HomeNewRows.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct HomeNewRows: View {
    @EnvironmentObject var modelData : ModelData
    
    var shows: [Show] { modelData.shows.filter { $0.addedToUserShows } }
    
    var newSeasons: [Show] {
        shows
            .filter { $0.userSpecificValues!.status == Status.NewSeason }
            .sorted { $0.name < $1.name }
            .sorted { $0.userSpecificValues!.lastUpdateDate ?? Date.distantPast > $1.userSpecificValues!.lastUpdateDate ?? Date.distantPast }
    }
    
    var newReleases: [Show] {
        shows
            .filter { $0.userSpecificValues!.status == Status.NewRelease }
            .sorted { $0.name < $1.name }
            .sorted { $0.userSpecificValues!.lastUpdateDate ?? Date.distantPast > $1.userSpecificValues!.lastUpdateDate ?? Date.distantPast }
    }
    
    var catchingUp: [Show] {
        shows
            .filter { $0.userSpecificValues!.status == Status.CatchingUp }
            .sorted { $0.name < $1.name }
            .sorted { $0.userSpecificValues!.lastUpdateDate ?? Date.distantPast > $1.userSpecificValues!.lastUpdateDate ?? Date.distantPast }
    }
    
    var body: some View {
        
        CurrentlyAiringRow()
        
        Divider()
        
        if (!newSeasons.isEmpty) {
            ScrollShowRow(items: newSeasons, scrollName: "New Seasons")
            Divider()
        }
        
        if (!newReleases.isEmpty) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("New Releases")
                        .background()
                        .font(.title)
                    Text("New shows that you have started")
                        .font(.subheadline)
                }
                .padding(.horizontal, 2)
                SquareTileScrollRow(items: newReleases, scrollType: ScrollRowType.NoExtraText)
            }
            Divider()
        }
        
        if (!catchingUp.isEmpty) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Catching Up")
                        .background()
                        .font(.title)
                    Text("Shows you are catching up on to get up to date")
                        .font(.subheadline)
                }
                .padding(.horizontal, 2)
                SquareTileScrollRow(items: catchingUp, scrollType: ScrollRowType.NoExtraText)
            }
            Divider()
        }
        
    }
}

struct HomeNewRows_Previews: PreviewProvider {
    static var previews: some View {
        HomeNewRows()
            .environmentObject(ModelData())
    }
}

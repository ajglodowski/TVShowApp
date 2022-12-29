//
//  HomeNewRows.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI

struct HomeNewRows: View {
    @EnvironmentObject var modelData : ModelData
    
    var newSeasons: [Show] {
        modelData.shows
            .filter { $0.status == Status.NewSeason }
            .sorted { $0.name < $1.name }
            .sorted { $0.lastUpdateDate ?? Date(timeIntervalSince1970: 0) > $1.lastUpdateDate ?? Date(timeIntervalSince1970: 0) }
    }
    
    var newReleases: [Show] {
        modelData.shows
            .filter { $0.status == Status.NewRelease }
            .sorted { $0.name < $1.name }
            .sorted { $0.lastUpdateDate ?? Date(timeIntervalSince1970: 0) > $1.lastUpdateDate ?? Date(timeIntervalSince1970: 0) }
    }
    
    var catchingUp: [Show] {
        modelData.shows
            .filter { $0.status == Status.CatchingUp }
            .sorted { $0.name < $1.name }
            .sorted { $0.lastUpdateDate ?? Date(timeIntervalSince1970: 0) > $1.lastUpdateDate ?? Date(timeIntervalSince1970: 0) }
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
                SquareTileScrollRow(items: newReleases, scrollType: 0)
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
                SquareTileScrollRow(items: catchingUp, scrollType: 0)
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

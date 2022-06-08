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
    }
    
    var newReleases: [Show] {
        modelData.shows
            .filter { $0.status == Status.NewRelease }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        
        CurrentlyAiringRow()
            .ignoresSafeArea()
        
        ScrollShowRow(items: newSeasons, scrollName: "New Seasons")
            .ignoresSafeArea()
        
        VStack(alignment: .leading) {
            Text("New Release")
                .background()
                .font(.title)
            Text("New shows that you have started")
                .font(.subheadline)
            SquareTileScrollRow(items: newReleases, scrollType: 0)
        }
        .ignoresSafeArea()
    }
}

struct HomeNewRows_Previews: PreviewProvider {
    static var previews: some View {
        HomeNewRows()
            .environmentObject(ModelData())
    }
}

//
//  CurrentlyAiring.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/1/22.
//

import SwiftUI

struct CurrentlyAiringRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var shows: [Show] {
        modelData.shows.filter { $0.addedToUserShows }
    }
    
    var currentlyAiring: [Show] {
        shows
            .filter { $0.currentlyAiring }
            .filter { $0.status! == Status.CurrentlyAiring }
            .sorted { $0.airdate!.id < $1.airdate!.id }
    }
    
    var currentlyAiringGroups: [AirDate:[Show]] {
        var output : [AirDate:[Show]] = [:]
        for c in currentlyAiring {
            if (output[c.airdate!] == nil) { output[c.airdate!] = [c] }
            else { output[c.airdate!]!.append(c) }
        }
        return output
    }
    
    var today: AirDate {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return AirDate.allCases.first(where: { $0.id+1 == weekday}) ?? AirDate.Other
    }
    
    var body: some View {
        if (!currentlyAiring.isEmpty) {
            VStack(alignment: .leading) {
                Text("Currently Airing")
                    .font(.title)
                    .padding(.horizontal, 2)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (alignment: .top) { // Put days next to each other
                        ForEach(AirDate.allCases) { day in
                            if (currentlyAiringGroups[day] != nil) {
                                if (day != today) { OtherTiles(currentlyAiringGroups: currentlyAiringGroups, day: day) }
                                else { TodayTile(currentlyAiringGroups: currentlyAiringGroups, day: day) }
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

struct TodayTile: View {
    var currentlyAiringGroups: [AirDate:[Show]]
    var day: AirDate
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) { // Day Group
                Text(day.rawValue)
                    .padding(.top, 5)
                    .bold()
                HStack(spacing: 0) {
                    ForEach(currentlyAiringGroups[day]!) { s in
                        //NavigationLink(destination: ShowDetail(showId: s.id, show: s)) {
                        NavigationLink(destination: ShowDetail(showId: s.id)) {
                            ShowSquareTile(show: s, titleShown: true)
                        }
                        .foregroundColor(Color.primary)
                        //.padding(.horizontal, 1)
                    }
                }
                .padding(.vertical, 5)
            }
            .background(.quaternary)
            .cornerRadius(20)
            .padding(.vertical, 5)
            Text("Today")
                .bold()
                .padding(6)
                .foregroundColor(.white)
                .background(Capsule().fill(.blue))
        }
    }
}

struct OtherTiles: View {
    var currentlyAiringGroups: [AirDate:[Show]]
    var day: AirDate
    var body: some View {
        VStack(spacing: 0) { // Day Group
            Text(day.rawValue)
                .padding(.top, 5)
                .bold()
            HStack(spacing: 0) {
                ForEach(currentlyAiringGroups[day]!) { s in
                    //NavigationLink(destination: ShowDetail(showId: s.id, show: s)) {
                    NavigationLink(destination: ShowDetail(showId: s.id)) {
                        ShowSquareTile(show: s, titleShown: true)
                    }
                    .foregroundColor(Color.primary)
                    //.padding(.horizontal, 1)
                }
            }
            .padding(.vertical, 5)
        }
        .background(.quaternary)
        .cornerRadius(20)
        .padding(.vertical, 5)
    }
}

struct CurrentlyAiring_Previews: PreviewProvider {
    static var previews: some View {
        CurrentlyAiringRow()
            .environmentObject(ModelData())
    }
}

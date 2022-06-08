//
//  CurrentlyAiring.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/1/22.
//

import SwiftUI

struct CurrentlyAiringRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var currentlyAiring: [Show] {
        modelData.shows
            .filter { $0.status == Status.CurrentlyAiring }
            .sorted { $0.airdate.id < $1.airdate.id }
    }
    
    var currentlyAiringGroups: [AirDate:[Show]] {
        var output : [AirDate:[Show]] = [:]
        for c in currentlyAiring {
            if (output[c.airdate] == nil) {
                var newAr: [Show] = [c]
                output[c.airdate] = newAr
            } else {
                output[c.airdate]!.append(c)
            }
        }
        //print(output)
        return output
    }
    
    var today: AirDate {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return AirDate.allCases.first(where: { $0.id+1 == weekday}) ?? AirDate.Other
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Currently Airing")
                .font(.title)
            ScrollView(.horizontal) {
                HStack (alignment: .top) { // Put days next to each other
                    ForEach(AirDate.allCases) { day in
                        //Text(day.rawValue)
                        if (currentlyAiringGroups[day] != nil) {
                            if (day != today) {
                                OtherTiles(currentlyAiringGroups: currentlyAiringGroups, day: day)
                            } else {
                                TodayTile(currentlyAiringGroups: currentlyAiringGroups, day: day)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

struct TodayTile: View {
    var currentlyAiringGroups: [AirDate:[Show]]
    var day: AirDate
    var body: some View {
        VStack {
            VStack { // Day Group
                Text(day.rawValue)
                HStack {
                    ForEach(currentlyAiringGroups[day]!) { s in
                        NavigationLink(destination: ShowDetail(show: s)) {
                            ShowSquareTile(show: s, scrollType: 0)
                        }
                        .foregroundColor(Color.primary)
                    }
                }
                
            }
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, lineWidth: 2)
            )
            .padding(.leading, 10)
            .padding(.top, 5)
            .padding(.bottom, 5)
            Text("Today")
        }
    }
}

struct OtherTiles: View {
    var currentlyAiringGroups: [AirDate:[Show]]
    var day: AirDate
    var body: some View {
        VStack { // Day Group
            Text(day.rawValue)
            HStack {
                ForEach(currentlyAiringGroups[day]!) { s in
                    NavigationLink(destination: ShowDetail(show: s)) {
                        ShowSquareTile(show: s, scrollType: 0)
                    }
                    .foregroundColor(Color.primary)
                }
            }
            
        }
        .padding(2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary, lineWidth: 2)
        )
        .padding(.leading, 10)
        .padding(.top, 5)
        .padding(.bottom, 5)
    }
}

struct CurrentlyAiring_Previews: PreviewProvider {
    
    static var previews: some View {
        CurrentlyAiringRow()
            .environmentObject(ModelData())
    }
}

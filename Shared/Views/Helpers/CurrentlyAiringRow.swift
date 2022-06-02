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
                HStack { // Put days next to each other
                    ForEach(AirDate.allCases) { day in
                        //Text(day.rawValue)
                        if (currentlyAiringGroups[day] != nil) {
                            if (day != today) {
                                VStack { // Day Group
                                    Text(day.rawValue)
                                    HStack {
                                        ForEach(currentlyAiringGroups[day]!) { s in
                                            NavigationLink(destination: ShowDetail(show: s)) {
                                                ShowSquareTile(show: s, scrollType: 0)
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .padding(.leading, 10)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .ignoresSafeArea()
                            } else {
                                VStack { // Day Group
                                    Text(day.rawValue)
                                    HStack {
                                        ForEach(currentlyAiringGroups[day]!) { s in
                                            NavigationLink(destination: ShowDetail(show: s)) {
                                                ShowSquareTile(show: s, scrollType: 0)
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                                .padding(.leading, 10)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .ignoresSafeArea()
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

struct CurrentlyAiring_Previews: PreviewProvider {
    
    static var previews: some View {
        CurrentlyAiringRow()
            .environmentObject(ModelData())
    }
}

//
//  CurrentlyAiring.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/1/22.
//

import SwiftUI

struct CurrentlyAiringRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @StateObject var vm = ShowsByStatusViewModel()
    
    var isLoading: Bool { vm.isLoading }
    
    var shows: [Show] { vm.shows ?? [] }
    
    var currentlyAiring: [Show] {
        shows
            .filter { $0.airdate != nil }
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
    
    var sortedDaysWithShows: [AirDate] {
        AirDate.allCases.filter { currentlyAiringGroups[$0] != nil }
    }
    
    var initialTab: AirDate {
        // If today has shows, start with today, otherwise start with first available day
        if currentlyAiringGroups[today] != nil {
            return today
        } else if let firstDay = sortedDaysWithShows.first {
            return firstDay
        } else {
            return AirDate.Other
        }
    }
    
    func airdateText(day: AirDate) -> String {
        if (day == today) {
            return "\(day.rawValue) (Today)"
        } else {
            return day.rawValue
        }
    }
    
    @State private var selectedDay: AirDate = AirDate.Other
    
    
    
    var LinkDestination: some View {
        var filters = ShowFilters()
        let status = Status(id: CurrentlyAiringStatusId, name: "Currently Airing", created_at: Date(), update_at: Date())
        filters.userStatuses = [status]
        return ShowSearch(
            searchType: ShowSearchType.watchlist,
            currentUserId: modelData.currentUser?.id,
            initialFilters: filters,
            includeNavigation: false
        )
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                NavigationLink(destination: LinkDestination) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                Text("Currently Airing")
                                    .font(.headline)
                                    .padding(.horizontal, 2)
                            }
                            Text("Shows you've got marked as currently airing, grouped by their airdate.")
                                .font(.subheadline)
                                .padding(.horizontal, 2)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                }
                if (isLoading) {
                        Picker("Airdate", selection: $selectedDay) {
                            Text("Loading...")
                                .font(.subheadline)
                        }
                        .pickerStyle(.segmented)
                        SquareTileScrollRowLoading()
                }
                else if (!currentlyAiring.isEmpty) {
                    // Day picker
                    Picker("Airdate", selection: $selectedDay) {
                        ForEach(sortedDaysWithShows) { day in
                            Text(airdateText(day: day)).tag(day)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Content for selected day
                    DayContent(
                        shows: currentlyAiringGroups[selectedDay] ?? [],
                        day: selectedDay,
                        isToday: selectedDay == today
                    )
                }
            }
        }
        .onAppear {
            selectedDay = initialTab
        }
        .task(id: modelData.currentUser) {
            if (modelData.currentUser != nil) {
                await vm.loadShowsByStatus(userId: modelData.currentUser!.id, statusId: CurrentlyAiringStatusId)
                selectedDay = initialTab
            }
        }
    }
}

struct DayContent: View {
    var shows: [Show]
    var day: AirDate
    var isToday: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(shows) { show in
                    NavigationLink(destination: ShowDetail(showId: show.id)) {
                        ShowSquareTile(show: show, titleShown: true)
                    }
                    .foregroundColor(Color.primary)
                }
            }
            .padding(.horizontal, 5)
        }
    }
}

// Keep the old DayTile for reference but it's no longer used
struct DayTile: View {
    var today: Bool
    var currentlyAiringGroups: [AirDate:[Show]]
    var day: AirDate
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) { // Day Group
                Text(day.rawValue)
                    .padding(.top, 5)
                    .bold()
                ScrollView(.horizontal, showsIndicators: false) {
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
            }
            if (today) {
                Text("Today")
                    .bold()
                    .padding(6)
                    .background(Capsule().fill(.quaternary))
            }
        }
        .background(.quaternary)
        .cornerRadius(20)
        .padding(.vertical, 5)
    }
}

#Preview {
    CurrentlyAiringRow()
        .environmentObject(ModelData())
}

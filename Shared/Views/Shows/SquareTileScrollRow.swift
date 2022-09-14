//
//  SquareTileScrollRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI

struct SquareTileScrollRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var items: [Show]
    
    var scrollType: Int
    
    func isOutNow(s: Show) -> Bool {
        if (s.status == Status.ComingSoon) {
            if ((s.releaseDate != nil) && (s.releaseDate! < Date.now)) {
                return true
            }
        }
        return false
    }
    
    func showIndex(show: Show) -> Int {
        modelData.shows.firstIndex(where: { $0.id == show.id})!
    }
    
    func getAboveExtraText(s: Show) -> [String]? {
        switch scrollType {
        case 1:
            return [s.airdate!.rawValue]
        case 2:
            if (!isOutNow(s: s)) {
                //print(s)
                return ["In \(String(Calendar.current.dateComponents([.day], from: Date.now, to: s.releaseDate!).day!)) days"]
            } else {
                return ["Out Now"]
            }
        default:
            return nil
        }
    }
    
    func getBelowExtraText(s: Show) -> [String]? {
        switch scrollType {
        case 2:
            let day = DateFormatter()
            day.dateFormat = "EEEE"
            let cal = DateFormatter()
            cal.dateFormat = "MMM d"
            return ["\(day.string(from: s.releaseDate!))  \(cal.string(from: s.releaseDate!))"]
        default:
            return nil
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { show in
                        VStack {
                            NavigationLink(destination: ShowDetail(showId: show.id)) {
                                ShowSquareTile(show: show, aboveExtraText: getAboveExtraText(s: show), belowExtraText: getBelowExtraText(s: show))
                            }
                            .foregroundColor(.primary)
                            if (scrollType == 2 && isOutNow(s: show) ) {
                                Button(action: {
                                    let day = DateFormatter()
                                    day.dateFormat = "EEEE"
                                    //print(showIndex(show: show))
                                    modelData.shows[showIndex(show: show)].status = Status.CurrentlyAiring
                                    modelData.shows[showIndex(show: show)].airdate = getAirDateFromString(day: day.string(from: show.releaseDate!))
                                    modelData.shows[showIndex(show: show)].releaseDate = nil
                                }) {
                                    Text("Add to \n Currently Airing")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                    }
                }
            }
            //.frame(height: 185)
        
        }
    }
}

struct SquareTileScrollRow_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ScrollView {
            VStack {
                SquareTileScrollRow(items: shows, scrollType: 0)
                SquareTileScrollRow(items: shows, scrollType: 1)
                SquareTileScrollRow(items: shows.filter {$0.status == Status.ComingSoon}, scrollType: 2)
            }
        }
    }
}

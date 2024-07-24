//
//  SquareTileScrollRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI

enum ScrollRowType {
    case NoExtraText
    case Airdate
    case ComingSoon
    case StatusDisplayed
}


struct SquareTileScrollRow: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var uid: String? { modelData.currentUser?.id }
    
    var items: [Show]
    
    var scrollType: ScrollRowType
    
    func isOutNow(s: Show) -> Bool {
        if (s.addedToUserShows && s.userSpecificValues!.status.id == ComingSoonStatusId) {
            if ((s.releaseDate != nil) && (s.releaseDate! < Date.now)) { return true }
        }
        return false
    }
    
    func getAboveExtraText(s: Show) -> [String]? {
        switch scrollType {
        case ScrollRowType.Airdate:
            return [s.airdate!.rawValue]
        case ScrollRowType.ComingSoon:
            if (isOutNow(s: s)) { return ["Out Now"] }
            else {
                let daysTil = Calendar.current.dateComponents([.day], from: Date.now, to: s.releaseDate!).day!
                return ["\(daysTil < 1 ? "Within the day" : "In \(daysTil) days" )"]
            }
        default:
            return nil
        }
        return nil
    }
    
    func getBelowExtraText(s: Show) -> [String]? {
        switch scrollType {
        case ScrollRowType.ComingSoon:
            let day = DateFormatter()
            day.dateFormat = "EEEE"
            let cal = DateFormatter()
            cal.dateFormat = "MMM d"
            return ["\(day.string(from: s.releaseDate!))  \(cal.string(from: s.releaseDate!))"]
        case ScrollRowType.StatusDisplayed:
            return ["\(s.userSpecificValues!.status.name)"]
        default:
            return nil
        }
        return nil
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { show in
                        VStack {
                            NavigationLink(destination: ShowDetail(showId: show.id)) {
                                ShowSquareTile(show: show, titleShown: true, aboveExtraText: getAboveExtraText(s: show), belowExtraText: getBelowExtraText(s: show))
                            }
                            .foregroundColor(.primary)
                            if (scrollType == ScrollRowType.ComingSoon && isOutNow(s: show) ) {
                                Button(action: {
                                    Task {
                                        if (uid != nil) {
                                            let success = await updateUserShowData(updateType: UserUpdateCategory.UpdatedStatus, userId: uid!, showId: show.id, seasonChange: nil, ratingChange: nil, statusChange: Status.init(id: CurrentlyAiringStatusId, name: "Currently Airing", created_at: Date(), update_at: Date()))
                                            if (success) {
                                                await modelData.reloadAllShowData(showId: show.id, userId: uid)
                                            }
                                        }
                                    }
                                }) {
                                    Text("Add to \n Currently Airing")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                    }
                }
                //.padding(.horizontal, 5)
            }
        }
    }
}

struct SquareTileScrollRow_Previews: PreviewProvider {
    
    static var shows = ModelData().shows
    
    static var previews: some View {
        ScrollView {
            VStack {
                SquareTileScrollRow(items: shows, scrollType: ScrollRowType.NoExtraText)
                SquareTileScrollRow(items: shows, scrollType: ScrollRowType.Airdate)
                SquareTileScrollRow(items: shows.filter {$0.addedToUserShows && $0.userSpecificValues!.status.id == ComingSoonStatusId}, scrollType: ScrollRowType.ComingSoon)
            }
        }
    }
}

//
//  SquareTileScrollRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/12/21.
//

import Foundation
import SwiftUI

struct SquareTileScrollRow: View {
    
    var items: [Show]
    
    var scrollType: Int
    
    func getAboveExtraText(s: Show) -> [String]? {
        switch scrollType {
        case 1:
            return [s.airdate.rawValue]
        case 2:
            return ["In \(String(Calendar.current.dateComponents([.day], from: Date.now, to: s.releaseDate!).day! + 1)) days"]
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
                        NavigationLink(destination: ShowDetail(show: show)) {
                            ShowSquareTile(show: show, aboveExtraText: getAboveExtraText(s: show), belowExtraText: getBelowExtraText(s: show))
                        }
                        .foregroundColor(.primary)
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
        VStack {
            SquareTileScrollRow(items: shows, scrollType: 0)
            SquareTileScrollRow(items: shows, scrollType: 1)
        }
    }
}

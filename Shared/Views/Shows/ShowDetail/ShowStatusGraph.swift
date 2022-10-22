//
//  ShowStatusGraph.swift
//  TV Show App
//
//  Created by AJ Glodowski on 10/13/22.
//

import SwiftUI
import Charts

struct ShowStatusGraph: View {
    
    var show : Show
    var backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Show Status Counts:")
                .font(.headline)
            ScrollView(.horizontal) {
                Chart {
                    ForEach(Status.allCases.sorted {
                        show.statusCounts[$0] ?? 0 > show.statusCounts[$1] ?? 0
                    }) { status in
                        BarMark(
                            x: .value("Status", status.rawValue),
                            y: .value("Count", show.statusCounts[status]!)
                        )
                        .annotation(position: .top) {
                            Text(String(show.statusCounts[status]!))
                        }
                        .foregroundStyle(by: .value("Status", status.rawValue))
                        //.foregroundStyle(rating.color)
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea.frame(height:250)
                }
                /*
                 .chartForegroundStyleScale([
                 "Disliked": Rating.Disliked.color, "Meh": Rating.Meh.color, "Liked": Rating.Liked.color, "Loved": Rating.Loved.color
                 ])
                 */
                .padding(.top, 25)
            }
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
        .foregroundColor(.white)
    }
}

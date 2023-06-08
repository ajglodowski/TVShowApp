//
//  ShowRatingsGraph.swift
//  TV Show App
//
//  Created by AJ Glodowski on 9/1/22.
//

import SwiftUI
import Charts

struct ShowRatingsGraph: View {
    
    //@EnvironmentObject var modelData: ModelData
    
    var show : Show
    var backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Show Rating Counts:")
                .font(.headline)
            if (show.avgRating.isNaN) {
                Text("This show hasn't been rated yet")
            } else {
                Text("Average Rating Value: \(show.avgRating)")
            }
            Chart {
                ForEach(Rating.allCases.sorted {
                    show.ratingCounts[$0] ?? 0 > show.ratingCounts[$1] ?? 0
                }) { rating in
                    BarMark(
                        x: .value("Rating", rating.rawValue),
                        y: .value("Count", show.ratingCounts[rating]!)
                    )
                    .annotation(position: .top) {
                        Text(String(show.ratingCounts[rating]!))
                    }
                    .foregroundStyle(by: .value("Rating", rating.rawValue))
                    //.foregroundStyle(rating.color)
                }
            }
            .chartPlotStyle { plotArea in
                plotArea.frame(height:250)
            }
            .chartForegroundStyleScale([
                "Disliked": Rating.Disliked.color, "Meh": Rating.Meh.color, "Liked": Rating.Liked.color, "Loved": Rating.Loved.color
            ])
            .padding(.top, 25)
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
        .foregroundColor(.white)
    }
}

#Preview {
    ScrollView {
        VStack {
            ShowRatingsGraph(show: SampleShow, backgroundColor: .white)
        }
    }
}

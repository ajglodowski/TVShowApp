//
//  ShowRatingsGraph.swift
//  TV Show App
//
//  Created by AJ Glodowski on 9/1/22.
//

import SwiftUI
import Charts

struct ShowRatingsGraph: View {
    
    @StateObject var ratingsCountsVm = ShowRatingsViewModel()
    
    var backgroundColor: Color
    var showId: Int
    
    var ratingCounts: [Rating: Int]? { ratingsCountsVm.ratingCounts }
    
    var avgRating: Double? {
        if (ratingCounts == nil) { return nil }
        var sum = 0
        var totalRatings = 0
        for (key, value) in ratingCounts! {
            totalRatings += value
            sum += (key.pointValue * value)
        }
        return Double(sum) / Double(totalRatings)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Show Rating Counts:")
                    .font(.headline)
                Spacer()
                Button (action: {
                    Task {
                        await ratingsCountsVm.loadRatingCounts(showId: showId)
                    }
                }) {
                    Text("Refresh Rating Data")
                }
                .buttonStyle(.bordered)
            }
            if (ratingCounts == nil) {
                Text("Loading graph data")
            } else {
                if (avgRating!.isNaN) {
                    Text("This show hasn't been rated yet")
                } else {
                    Text("Average Rating Value: \(avgRating!)")
                }
                RatingGraph(ratingCounts: ratingCounts!)
            }
        }
        .task {
            await ratingsCountsVm.loadRatingCounts(showId: showId)
        }
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
        .foregroundColor(.white)
    }
}

struct RatingGraph: View {
    var ratingCounts: [Rating: Int]
    
    var body: some View {
        Chart {
            ForEach(Rating.allCases.sorted {
                $0.pointValue < $1.pointValue
            }) { rating in
                BarMark(
                    x: .value("Rating", rating.rawValue),
                    y: .value("Count", ratingCounts[rating]!)
                )
                .annotation(position: .top) {
                    Text(String(ratingCounts[rating]!))
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
    
}

#Preview {
    let counts = [Rating.Meh: 0, Rating.Liked: 20, Rating.Loved: 50, Rating.Disliked: 35]
    return (
        ScrollView {
            VStack {
                ShowRatingsGraph(backgroundColor: .blue, showId: MockSupabaseShow.id)
            }
        }
    )
}

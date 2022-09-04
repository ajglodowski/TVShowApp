//
//  RatingsGraphs.swift
//  TV Show App
//
//  Created by AJ Glodowski on 9/2/22.
//

import SwiftUI
import Charts

struct AverageRatingsGraphs: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var ratedShows: [Show] { modelData.shows.filter { !$0.avgRating.isNaN } }
    
    var serviceAvgRatings: [(Service, Double)] {
        var out = [(Service,Double)]()
        for service in Service.allCases {
            let servShows = ratedShows
                .filter { $0.service == service}
            if (!servShows.isEmpty) {
                let servCount = Double(servShows.count)
                var servSum: Double = 0.0
                for show in servShows {
                    servSum += show.avgRating
                }
                out.append((service, servSum/servCount))
            }
        }
        out = out.sorted { $0.1 > $1.1 }
        return out
    }
    
    var body: some View {
        VStack {
            
            overallAvgRatingByService
            
        }
    }
    
    
    
    var overallAvgRatingByService: some View {
        VStack(alignment: .leading) {
            Text("Avg Rating by Service:")
                .font(.headline)
            Chart {
                ForEach(serviceAvgRatings, id:\.0) { (service, avgRating) in
                    BarMark(
                        x: .value("Rating", service.rawValue),
                        y: .value("Average Rating", avgRating)
                    )
                    .annotation(position: .top) {
                        Text("\(avgRating, specifier: "%.3f")")
                    }
                    .foregroundStyle(by: .value("Service", service.rawValue))
                    //.foregroundStyle(rating.color)
                }
            }
            .chartPlotStyle { plotArea in
                plotArea.frame(height:250)
            }
            
            .chartForegroundStyleScale([
                "ABC": Service.ABC.color, "Amazon": Service.Amazon.color, "FX": Service.FX.color, "Hulu": Service.Hulu.color, "HBO": Service.HBO.color, "Netflix": Service.Netflix.color, "Apple TV+": Service.Apple.color, "NBC": Service.NBC.color, "Disney+": Service.Disney.color, "CW": Service.CW.color,  "Showtime": Service.Showtime.color, "AMC": Service.AMC.color, "USA": Service.USA.color, "Viceland": Service.Viceland.color, "Other": Service.Other.color
            ])
            
            .padding(.top, 25)
        }
    }
    
}

struct AverageRatingsGraphs_Previews: PreviewProvider {
    static var previews: some View {
        AverageRatingsGraphs()
    }
}

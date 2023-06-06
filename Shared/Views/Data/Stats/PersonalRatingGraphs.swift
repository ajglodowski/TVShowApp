//
//  PersonalRatingGraphs.swift
//  TV Show App
//
//  Created by AJ Glodowski on 9/2/22.
//

import SwiftUI
import Charts

struct PersonalRatingGraphs: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var ratedShows: [Show] { modelData.shows.filter { $0.addedToUserShows && $0.userSpecificValues!.rating != nil } }
    
    var ratingsCounts: [Rating:Int] {
        var out = [Rating:Int]()
        for r in Rating.allCases {
            out[r] = 0
        }
        for show in ratedShows {
            out[show.userSpecificValues!.rating!]! += 1
        }
        return out
    }
    
    struct TagRatingCount: Identifiable {
        var tag: Tag
        var rating: Rating
        var count: Int
        var id: UUID = UUID()
    }
    
    var tagRatingCounts: [TagRatingCount] {
        var output = [TagRatingCount]()
        for tag in Tag.allCases {
            for rating in Rating.allCases {
                let count = ratedShows.filter { $0.tags != nil && $0.tags!.contains(tag) && $0.userSpecificValues!.rating == rating}.count
                let add = TagRatingCount(tag: tag, rating: rating, count: count)
                output.append(add)
            }
        }
        //output = output.sorted { $0.count > $1.count }
        output = output.filter { $0.count > 0 }
        return output
    }
    
    var avgTagRating: [Tag:Double] {
        var output = [Tag:Double]()
        for tag in Tag.allCases {
            let tagged = ratedShows.filter { $0.tags != nil && $0.tags!.contains(tag) }
            if (!tagged.isEmpty) {
                var sum = 0
                for show in tagged {
                    sum += (show.userSpecificValues!.rating!.pointValue)
                }
                //if (totalRatings == 0 || sum == 0) { return 0 }
                output[tag] = Double(sum) / Double(tagged.count)
            }
        }
        return output
    }
    
    func avgTagRating(tag: Tag) -> Double {
        let tagged = ratedShows.filter { $0.tags != nil && $0.tags!.contains(tag) }
        var sum = 0
        for show in tagged {
            sum += (show.userSpecificValues!.rating!.pointValue)
        }
        return Double(sum) / Double(tagged.count)
    }
    
    func numShowsFromTag(tag: Tag) -> Int {
        ratedShows
            .filter { $0.tags != nil && $0.tags!.contains(tag) }
            .count
    }
    
    var body: some View {
        List {
             yourRatings
             
            tagsByRating
            
            AverageRatingsGraphs()
            
        }
    }
    
    var yourRatings: some View {
        VStack(alignment: .leading) {
            Text("Your Rating Counts:")
                .font(.headline)
            Chart {
                ForEach(Rating.allCases.sorted {
                    ratingsCounts[$0]! > ratingsCounts[$1]!
                }) { rating in
                    BarMark(
                        x: .value("Rating", rating.rawValue),
                        y: .value("Count", ratingsCounts[rating]!)
                    )
                    .annotation(position: .top) {
                        Text(String(ratingsCounts[rating]!))
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
    
    var tagsByRating: some View {
        VStack {
            Text("Tags by Rating:")
                .font(.headline)
            Chart {
                ForEach(tagRatingCounts.sorted { avgTagRating(tag: $0.tag) > avgTagRating(tag: $1.tag) } ) { obj in
                    BarMark(
                        x: .value("Rating", obj.tag.rawValue),
                        y: .value("Count", obj.count)
                    )
                    /*
                     .annotation(position: .top) {
                         Text("Average Rating value: \(avgTagRating[obj.tag]!)")
                         Text("From \(numShowsFromTag(tag:obj.tag)) shows")
                     }
                     */
                    .foregroundStyle(by: .value("Rating", obj.rating.rawValue))
                    //.foregroundStyle(rating.color)
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartForegroundStyleScale([
                "Disliked": Rating.Disliked.color, "Meh": Rating.Meh.color, "Liked": Rating.Liked.color, "Loved": Rating.Loved.color
            ])
            .chartPlotStyle { plotArea in
                plotArea.frame(width: (CGFloat(Tag.allCases.count) * 50),height:250)
            }
        }
    }
}

struct PersonalRatingGraphs_Previews: PreviewProvider {
    static var previews: some View {
        PersonalRatingGraphs()
    }
}

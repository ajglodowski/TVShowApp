//
//  TagsGraphs.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/26/22.
//

import SwiftUI
import Charts

struct TagsGraphs: View {
    
    @EnvironmentObject var modelData: ModelData
    
    struct TagsCount: Identifiable {
        var tag: Tag
        var count: Int
        //var service: Service
        var id: UUID = UUID()
    }
    
    struct ShowTagCount: Identifiable {
        var showCount: Int
        var tagCount: Int
        //var service: Service
        var id: UUID = UUID()
    }

    var tagsCounts: [TagsCount] {
        let validShows = modelData.shows.filter { ($0.tags != nil) }
        var tagAr: [TagsCount] = []
        for tag in Tag.allCases {
            let count = validShows.filter{ $0.tags!.contains(tag) }.count
            let adding = TagsCount(tag: tag, count: count)
            tagAr.append(adding)
        }
        return tagAr
    }
    
    var showTagsCounts: [ShowTagCount] {
        let validShows = modelData.shows.filter { ($0.tags != nil) }
        var tagCounts = [Int:Int]()
        for show in validShows {
            let tagCount = show.tags!.count
            if (tagCounts[tagCount] == nil) {
                tagCounts[tagCount] = 1
            } else {
                tagCounts[tagCount] = tagCounts[tagCount]! + 1
            }
        }
        var tagAr: [ShowTagCount] = []
        for (tagCount, showCount) in tagCounts {
            let add = ShowTagCount(showCount: showCount, tagCount: tagCount)
            tagAr.append(add)
        }
        return tagAr
    }
    
    var body: some View {
        VStack {
            //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            ScrollView(.horizontal) {
                Chart {
                    ForEach(tagsCounts.sorted(by: {$0.count > $1.count})) { tag in
                        BarMark(
                            x: .value("Tag", tag.tag.rawValue),
                            y: .value("Show Count", tag.count)
                            
                        )
                        .annotation(position: .top) {
                            Text(String(tag.count))
                        }
                        .foregroundStyle(by: .value("Tag", tag.tag.rawValue))
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea.frame(height:300)
                }
            }
            
            ScrollView(.horizontal) {
                Chart {
                    ForEach(showTagsCounts) { showTag in
                        BarMark(
                            x: .value("Tag Count", showTag.tagCount),
                            y: .value("Show Count", showTag.showCount)
                            
                        )
                        .annotation(position: .top) {
                            Text(String(showTag.showCount))
                        }
                        .foregroundStyle(by: .value("Tag Count", showTag.tagCount))
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea.frame(width: 300, height:300)
                }
            }
            
        }
    }
}

struct TagsGraphs_Previews: PreviewProvider {
    static var previews: some View {
        TagsGraphs()
    }
}

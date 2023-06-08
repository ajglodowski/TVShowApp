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
        var tagAr: [TagsCount] = []
        for tag in Tag.allCases {
            let count = modelData.shows.filter { $0.tags!.contains(tag) }.count
            let adding = TagsCount(tag: tag, count: count)
            tagAr.append(adding)
        }
        return tagAr
    }
    
    var showTagsCounts: [ShowTagCount] {
        let validShows = modelData.shows
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
            VStack {
                Text("Shows by Tags")
                    .font(.title)
                Chart {
                    ForEach(tagsCounts.sorted(by: {$0.count > $1.count})) { tag in
                        BarMark(
                            x: .value("Tag", tag.tag.rawValue),
                            y: .value("Show Count", tag.count)
                            
                        )
                        .annotation(position: .overlay) {
                            Text(String(tag.count))
                                .padding(2)
                                .background(.quaternary)
                                .cornerRadius(5)
                        }
                        .foregroundStyle(by: .value("Tag", tag.tag.rawValue))
                    }
                }
                .chartScrollableAxes(.horizontal)
                .chartPlotStyle { plotArea in
                    plotArea.frame(height:250)
                }
            }
            .frame(minHeight: 600)
            
            Text("Tags per show")
                .font(.title)
            Chart {
                ForEach(showTagsCounts) { showTag in
                    BarMark(
                        x: .value("Tag Count", showTag.tagCount),
                        y: .value("Show Count", showTag.showCount)
                        
                    )
                    .annotation(position: .top) {
                        VStack {
                            Text("\(showTag.tagCount) Tags")
                            Text("\(showTag.showCount) Shows")
                        }
                    }
                    .foregroundStyle(by: .value("Tag Count", showTag.tagCount))
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartPlotStyle { plotArea in
                plotArea.frame(height:350)
            }
             
            .padding(.top, 25)
            .padding()
            
        }
    }
}

struct TagsGraphs_Previews: PreviewProvider {
    static var previews: some View {
        TagsGraphs()
    }
}

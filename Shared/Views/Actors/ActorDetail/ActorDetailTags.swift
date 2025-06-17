//
//  ActorDetailTags.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/16/24.
//

import SwiftUI
import Charts

struct ActorDetailTags: View {
    
    @StateObject var vm = ActorDetailTagsViewModel()
    
    var showList: [Int]?
    var tagCounts: [Tag:Int]? { vm.tagCounts }
    
    func fetchCounts() async {
        if (self.showList == nil) { return }
        await vm.fetchTagDataForActor(showList: showList!)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Tags")
                Spacer()
                Button(action: {
                    Task {
                        await fetchCounts()
                    }
                }) {
                    Text("Refresh Tag Data")
                }
                .buttonStyle(.bordered)
                
            }
            if (tagCounts == nil) {
                Text("Loading Tag Data")
            } else {
                ScrollView(.horizontal) {
                    ActorDetailTagsGraph(tagCounts: tagCounts!)
                }
            }
        }
        .task(id: showList) {
            await fetchCounts()
        }
    }
}

struct ActorDetailTagsGraph: View {
    var tagCounts: [Tag:Int]
    
    var orderedTags: [Tag] {
        Array(tagCounts.keys).sorted { tagCounts[$0]! > tagCounts[$1]! }
    }
    
    var body: some View {
        Chart {
            ForEach(orderedTags) { tag in
                let count = tagCounts[tag]!
                BarMark(
                    x: .value("Tag", tag.name),
                    y: .value("Count", count)
                )
                .annotation(position: .top) {
                    Text(String(count))
                }
                .foregroundStyle(by: .value("Tag", tag.name))
            }
        }
        .chartPlotStyle { plotArea in
            plotArea.frame(height:250)
        }
        .padding(.top, 25)
    }
}

/*
#Preview {
    ActorDetailTags()
}
 */

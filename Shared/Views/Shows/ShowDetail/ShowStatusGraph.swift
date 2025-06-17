//
//  ShowStatusGraph.swift
//  TV Show App
//
//  Created by AJ Glodowski on 10/13/22.
//

import SwiftUI
import Charts

struct ShowStatusGraph: View {
    
    @StateObject var statusCountsVm = ShowStatusViewModel()
    
    var backgroundColor: Color
    var showId: Int
    
    var statusCounts: [Status: Int]? { statusCountsVm.statusCounts }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Show Status Counts:")
                .font(.headline)
            if (statusCounts == nil) {
                Text("Loading graph data")
            } else {
                StatusGraph(statusCounts: statusCounts!)
            }
        }
        .task {
            await statusCountsVm.loadStatusCounts(showId: showId)
        }
        .frame(minHeight: 400)
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
    }
}

struct StatusGraph: View {
    
    var statusCounts: [Status: Int]
    var statuses: [Status] { Array(statusCounts.keys) }
    
    var body: some View {
        Chart {
            ForEach(statuses.sorted { statusCounts[$0] ?? 0 > statusCounts[$1] ?? 0 }) { status in
                if (statusCounts[status] != nil) {
                    BarMark(
                        x: .value("Status", status.name),
                        y: .value("Count", statusCounts[status]!)
                    )
                    .annotation(position: .top) {
                        Text(String(statusCounts[status]!))
                    }
                    .foregroundStyle(by: .value("Status", status.name))
                }
            }
        }
        .chartPlotStyle { plotArea in
            plotArea.frame(height: 200)
        }
        .chartScrollableAxes(.horizontal)
        .padding(.top, 25)
    }
}

#Preview {
    ScrollView {
        VStack {
            ShowStatusGraph(backgroundColor: .white, showId: SampleShow.id)
        }
    }
}

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
            /*
            Chart {
                ForEach(Status.allCases.sorted { show.statusCounts[$0] ?? 0 > show.statusCounts[$1] ?? 0 }) { status in
                    if (show.statusCounts[status] != nil) {
                        BarMark(
                            x: .value("Status", status.rawValue),
                            y: .value("Count", show.statusCounts[status]!)
                        )
                        .annotation(position: .top) {
                            Text(String(show.statusCounts[status]!))
                        }
                        .foregroundStyle(by: .value("Status", status.rawValue))
                    }
                }
            }
            
            .chartPlotStyle { plotArea in
                plotArea.frame(height: 200)
            }
            .chartScrollableAxes(.horizontal)
            .padding(.top, 25)
             */
             
        }
        .frame(minHeight: 400)
        .padding()
        .background(backgroundColor.blendMode(.softLight))
        .cornerRadius(20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
    }
}

#Preview {
    ScrollView {
        VStack {
            ShowStatusGraph(show: SampleShow, backgroundColor: .white)
        }
    }
}

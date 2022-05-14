//
//  StatsPage.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/13/22.
//

import SwiftUI

struct StatsPage: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var colors = [Service.HBO: Color(red: 102/255, green: 51/255, blue: 153/255), Service.Hulu: Color(.green), Service.Netflix: Color(red: 229/255, green: 9/255, blue: 20/255), Service.Disney: Color(red: 17/255, green: 70/255, blue: 207/255), Service.Amazon: Color(red: 0/255, green: 168/255, blue: 225/255)
    ]
    
    var showCounts: [Service:Int] {
        var dict: [Service:Int] = [:]
        for service in Service.allCases {
            let count = modelData.shows.filter{ $0.service == service}.count
            dict[service] = count
        }
        return dict
    }
    
    var statusCounts: [Status:Int] {
        var statusDict: [Status:Int] = [:]
        for status in Status.allCases{
            let count = modelData.shows.filter{ $0.status == status}.count
            statusDict[status] = count
        }
        return statusDict
    }
    
    var showCountsScaled: [Service:Double] {
        var scaledDict: [Service:Double] = [:]
        let max = showCounts.values.max()!
        for item in showCounts {
            let add: Double = Double(item.value) / Double(max)
            scaledDict[item.key] = add * 100
        }
        return scaledDict
    }
    
    var statusCountsScaled: [Status:Double] {
        var statusScaledDict: [Status:Double] = [:]
        let statusMax = statusCounts.values.max()!
        for statusItem in statusCounts {
            let statusAdd: Double = Double(statusItem.value) / Double(statusMax)
            statusScaledDict[statusItem.key] = statusAdd * 100
        }
        return statusScaledDict
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                Text("Top Actors:")
                    .font(.headline)
                let topFive = modelData.actors.sorted{ $0.name < $1.name }.sorted { $0.shows.count > $1.shows.count}.prefix(5)
                VStack(alignment: .leading) {
                    ForEach(topFive) { act in
                        HStack {
                            Text(act.name)
                            Spacer()
                            Text(String(act.shows.count))
                        }
                        .padding([.leading, .trailing], 10.0)
                    }
                }
            }
            
            // Service show Counts
            VStack {
                Text("Service show counts:")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        let modifer: Double = 2.0;
                        ForEach(Service.allCases.sorted{ showCounts[$0] ?? 0 > showCounts[$1] ?? 0 }) { service in
                            VStack {
                                VStack {
                                    Capsule().frame(width: 15)
                                        .foregroundColor(colors[service])
                                        .frame(height: CGFloat((showCountsScaled[service] ?? 0) * modifer))
                                }
                                .frame(height: 100*modifer, alignment: .bottom)
                                Text(service.rawValue)
                                Text(String(showCounts[service] ?? 0))
                            }
                        }
                    }
                }
            }
            
            VStack {
                Text("Status counts:")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        let modifer: Double = 2.0;
                        ForEach(Status.allCases.sorted{ statusCounts[$0] ?? 0 > statusCounts[$1] ?? 0 }) { status in
                            VStack {
                                VStack {
                                    Capsule().frame(width: 15)
                                        .frame(height: CGFloat((statusCountsScaled[status] ?? 0) * modifer))
                                }
                                .frame(height: 100*modifer, alignment: .bottom)
                                Text(status.rawValue)
                                Text(String(statusCounts[status] ?? 0))
                            }
                        }
                    }
                }
            }
            
        }
        .navigationTitle("Stats Page")
    }
}

struct StatsPage_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        StatsPage()
            .environmentObject(modelData)
    }
}

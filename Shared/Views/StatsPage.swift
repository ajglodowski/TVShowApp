//
//  StatsPage.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/13/22.
//
import Charts
import SwiftUI

struct StatsPage: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var colors = [Service.HBO: Color(red: 102/255, green: 51/255, blue: 153/255), Service.Hulu: Color(.green), Service.Netflix: Color(red: 229/255, green: 9/255, blue: 20/255), Service.Disney: Color(red: 17/255, green: 70/255, blue: 207/255), Service.Amazon: Color(red: 0/255, green: 168/255, blue: 225/255)
    ]
    /*
    var statusCountsScaled: [Status:Double] {
        var statusScaledDict: [Status:Double] = [:]
        let statusMax = statusCounts.values.max()!
        for statusItem in statusCounts {
            let statusAdd: Double = Double(statusItem.value) / Double(statusMax)
            statusScaledDict[statusItem.key] = statusAdd * 100
        }
        return statusScaledDict
    }
     */
    
    var body: some View {
        List {
            
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
            
            ServiceChart()
            
            
            
            StatusChart()
            /*
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
             */
            
        }
        .navigationTitle("Stats Page")
    }
}

struct ServiceChart: View {
    
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
    
    var body: some View {
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
    }
}

struct StatusChart: View {
    @EnvironmentObject var modelData: ModelData
    
    struct StatusCount: Identifiable {
        var status: Status
        var count: Int
        var service: Service
        var id: UUID = UUID()
    }
    
    var statusCounts: [StatusCount] {
        var statusAr: [StatusCount] = []
        for status in Status.allCases {
            for service in Service.allCases {
                let count = modelData.shows.filter{ $0.status == status && $0.service == service}.count
                let adding = StatusCount(status: status, count: count, service: service)
                statusAr.append(adding)
            }
        }
        return statusAr
    }
    
    @State var selectedStatus: Status = Status.NeedsWatched
    
    var body: some View {
        //Text("Hello")
        VStack {
            VStack {
                Text("Shows by Status")
                    .font(.title)
                Chart {
                    ForEach(statusCounts.sorted(by: {$0.count > $1.count})) { stat in
                        BarMark(
                            x: .value("Stats", stat.status.rawValue),
                            y: .value("Shows", stat.count)
                        )
                        .foregroundStyle(by: .value("Service", stat.service.rawValue))
                    }
                }
                .frame(height: 400)
                .padding()
            }
            
            VStack {
                Text("Selected Status: "+selectedStatus.rawValue)
                
                Picker("Status", selection: $selectedStatus) {
                    ForEach(Status.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Chart {
                    ForEach(statusCounts.filter({
                        $0.status == selectedStatus
                    }).sorted(by: {$0.count > $1.count})) { s in
                        BarMark(
                            x: .value("Stats", s.count)
                        )
                        .foregroundStyle(by: .value("Service", s.service.rawValue))
                    }
                }
                .frame(height: 100)
            }
            .padding()
            //.chartLegend(position: .top)
        }
        
    }
}

struct StatsPage_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        StatsPage()
            .environmentObject(modelData)
    }
}

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
    
    /*
    var colors = [Service.HBO: Color(red: 102/255, green: 51/255, blue: 153/255), Service.Hulu: Color(.green), Service.Netflix: Color(red: 229/255, green: 9/255, blue: 20/255), Service.Disney: Color(red: 17/255, green: 70/255, blue: 207/255), Service.Amazon: Color(red: 0/255, green: 168/255, blue: 225/255)
    ]
     */
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
                NavigationLink(
                    destination: RatingGraphs(),
                    label: {
                        Text("Ratings Stats")
                    })
                .buttonStyle(PlainButtonStyle())
            }
            
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
            
            //ServiceChart()
            
            
            
            NewCharts()
            
            TagsGraphs()
            
            
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

/*
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
*/

struct NewCharts: View {
    @EnvironmentObject var modelData: ModelData
    
    struct StatusCount: Identifiable {
        var status: Status
        var count: Int
        var service: Service
        var id: UUID = UUID()
    }
    
    struct ServiceCount: Identifiable {
        //var status: Status
        var service: Service
        var count: Int
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
    
    func getStatusCount(status: Status) -> Int {
        modelData.shows.filter{ $0.status == status }.count
    }
    
    var serviceCounts: [ServiceCount] {
        var serviceAr: [ServiceCount] = []
        for service in Service.allCases {
            let count = modelData.shows.filter{ $0.service == service}.count
            let adding = ServiceCount(service: service, count: count)
            serviceAr.append(adding)
        }
        return serviceAr
    }
    
    var serviceColors: [String:Color] {
        var output = [String:Color]()
        for service in Service.allCases {
            output[service.rawValue] = service.color
        }
        return output
    }
    
    @State var selectedStatus: Status = Status.NeedsWatched
    
    var body: some View {
        //Text("Hello")
        /*
        VStack {
            ForEach(Service.allCases) { service in
                Text(service.rawValue)
                    //.foregroundColor(serviceColors[service.rawValue])
                    .foregroundColor(.green)
            }
        }
         */
        
        VStack {
            Text("Shows by Service")
                .font(.title)
            ScrollView(.horizontal) {
                
                Chart {
                    ForEach(serviceCounts.sorted(by: {$0.count > $1.count})) { serv in
                        BarMark(
                            x: .value("Service", serv.service.rawValue),
                            y: .value("Shows", serv.count)
                            
                        )
                        .annotation(position: .top) {
                            Text(String(serv.count))
                        }
                        //.foregroundStyle(getServiceColor(service: serv.service))
                        .foregroundStyle(by: .value("Service", serv.service.rawValue))
                    }
                }
                .chartForegroundStyleScale([
                    "ABC": Service.ABC.color, "Amazon": Service.Amazon.color, "FX": Service.FX.color, "Hulu": Service.Hulu.color, "HBO": Service.HBO.color, "Netflix": Service.Netflix.color, "Apple TV+": Service.Apple.color, "NBC": Service.NBC.color, "Disney+": Service.Disney.color, "CW": Service.CW.color,  "Showtime": Service.Showtime.color, "AMC": Service.AMC.color, "USA": Service.USA.color, "Viceland": Service.Viceland.color, "Other": Service.Other.color
                ])
                .chartPlotStyle { plotArea in
                    plotArea.frame(height:300)
                }
                
                 
                //
                //.frame(height: 400)
            //.padding()
            }
        }
         
         
        
        VStack {
            VStack {
                Text("Shows by Status")
                    .font(.title)
                ScrollView(.horizontal) {
                    
                    Chart {
                        ForEach(statusCounts.sorted { getStatusCount(status: $0.status) > getStatusCount(status: $1.status) }) { stat in
                            BarMark(
                                x: .value("Status", stat.status.rawValue),
                                y: .value("Shows", stat.count)
                            )
                            /*
                            .annotation(position: .top) {
                                Text(String(stat.count))
                            }
                             */
                            .foregroundStyle(by: .value("Service", stat.service.rawValue))
                        }
                    }
                    
                    .chartPlotStyle { plotArea in
                        plotArea.frame(height:300)
                    }
                     
                    .chartForegroundStyleScale([
                        "ABC": Service.ABC.color, "Amazon": Service.Amazon.color, "FX": Service.FX.color, "Hulu": Service.Hulu.color, "HBO": Service.HBO.color, "Netflix": Service.Netflix.color, "Apple TV+": Service.Apple.color, "NBC": Service.NBC.color, "Disney+": Service.Disney.color, "CW": Service.CW.color,  "Showtime": Service.Showtime.color, "AMC": Service.AMC.color, "USA": Service.USA.color, "Viceland": Service.Viceland.color, "Other": Service.Other.color
                    ])
                    //.frame(width: 600)
                     
                //.padding()
                }
            }
            /*
            VStack {
                Text("Selected Status: "+selectedStatus.rawValue)
                
                Picker("Status", selection: $selectedStatus) {
                    ForEach(Status.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                //.pickerStyle(SegmentedPickerStyle())
                
                /*
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
                 */
            }
            .padding()
            //.chartLegend(position: .top)
            */
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

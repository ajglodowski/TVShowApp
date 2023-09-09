//
//  NewData.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/9/23.
//

import SwiftUI
//import SwiftData

struct NewData: View {
    
    @EnvironmentObject var modelData: ModelData
    //@Environment(\.modelContext) private var modelContext
    
    //@Query() var userDetails: [ShowUserSpecificDetails]
    //@Query() var lastFetch: [LastUserFetch]
    
    //var userDetails: [ShowUserSpecificDetails]
    /*
    var lastUpdate: Date? {
        lastFetch.first?.fetchDate
    }
     */
    
    private static var formatter: DateFormatter = {
        let dF = DateFormatter()
        dF.dateFormat = "'MM'/'dd'/'yyyy'"
        dF.dateStyle = .long
        return dF
    }()
    
    var body: some View {
        VStack {
            /*
            Button(action: { addSampleData() }) {
                Text("Press me")
            }
            .buttonStyle(.bordered)
            if (lastUpdate != nil) {
                Text("Last Updated: \(NewData.formatter.string(from: lastUpdate!))")
            }
            ForEach(userDetails) { detailObj in
                VStack {
                    Text(detailObj.userId)
                    Text(detailObj.showId)
                    Text(detailObj.status.rawValue)
                }
                Button(action: {
                    modelContext.delete(detailObj)
                    try! modelContext.save()
                }) {
                    Text("Remove this")
                }
            }
             */
        }
        /*
        .task() {
            let toConvert = modelData.shows.filter { $0.addedToUserShows }.map { $0.userSpecificValues! }
            print(toConvert)
            syncUserSpecificDetailsToData(context: modelContext, data: toConvert)
        }
         */
    }
    /*
    func addSampleData() {
        modelContext.insert(SampleUserDetails)
        try! modelContext.save()
    }
     */
}

#Preview {
    NewData()
}

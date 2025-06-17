//
//  ActorDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/5/22.
//

import SwiftUI
import Charts

struct ActorDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    @StateObject var vm = ActorDetailViewModel()
        
    var actorId: Int
    var actor: Actor? { vm.actor }
    var shows: [Show]? { vm.shows }
    var showIds: [Int]? { vm.shows?.map { $0.id }}
    
    @State var actorEdited: Actor = Actor(id: -1)
    
    @State private var isPresented = false // Edit menu var
    
    var loggedShows: [Show] {
        if (shows == nil) { return [] }
        else { return shows!.filter { modelData.showDict[$0.id] != nil && modelData.showDict[$0.id]!.addedToUserShows } }
    }
    
    var newShows: [Show] { 
        if (shows == nil) { return [] }
        else { return shows!.filter { !loggedShows.contains($0) } }
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                if (actor != nil) {
                    let loadedActor = actor!
                    VStack {
                        Text(loadedActor.name)
                            .font(.title)
                            .padding()
                        Spacer()
                        
                        VStack (alignment: .leading) {
                            Text("Logged Shows \(loadedActor.name) has appeared in:")
                                .padding()
                            
                            ForEach(loggedShows.sorted { $0.name < $1.name }) { show in
                                NavigationLink(destination: ShowDetail(showId: show.id)) {
                                    ListShowRow(show: show)
                                    Divider()
                                }
                                .padding()
                            }
                        }
                        
                        VStack (alignment: .leading) {
                            Text("Other Shows \(loadedActor.name) has appeared in:")
                                .padding()
                            
                            ForEach(newShows.sorted { $0.name < $1.name }) { show in
                                NavigationLink(destination: ShowDetail(showId: show.id)) {
                                    ListShowRow(show: show)
                                    Divider()
                                }
                                .padding()
                            }
                        }
                        
                        ActorDetailTags(showList: showIds)
                        
                        //actorRatingsGraph
                        
                    }
                } else {
                    VStack {
                        Text("Loading Actor")
                    }
                }
            }
            .refreshable {
                await vm.fetchAllActorData(actorId: actorId)
            }
            .task {
                await vm.fetchAllActorData(actorId: actorId)
            }
            .foregroundColor(.white)
        }
        
        .navigationTitle(actor?.name ?? "Loading Actor")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Edit") {
            if (actor != nil) {
                actorEdited = actor!
                isPresented = true
            }
        })
        
        .sheet(isPresented: $isPresented) {
            NavigationView {
                ActorDetailEdit(isPresented: self.$isPresented, actor: $actorEdited)
                    .navigationTitle(actor!.name)
                    .navigationBarItems(leading: Button("Cancel") {
                        actorEdited = actor!
                        isPresented = false
                    }, trailing: Button("Done") {
                        if (actorEdited != actor) {
                            Task {
                                let success = await updateActor(actor: actorEdited)
                                if (success) {
                                    await vm.fetchAllActorData(actorId: actorId)
                                }
                            }
                        }
                        isPresented = false
                    })
            }
        }
    }

    /*
    var ratingsCounts: [Rating: Int] {
        var output = [Rating: Int]()
        for tag in Rating.allCases {
            output[tag] = 0
        }
        for (showId, showName) in actor.shows {
            //let showFound = modelData.shows.first(where: { $0.id == showId })
            let showFound = modelData.showDict[showId]
            if (showFound != nil && showFound!.rating != nil) {
                output[showFound!.rating!]! += 1
            }
        }
        return output
    }
    
    var avgRating: Double {
        var sum = 0
        var count = 0
        for (showId, _) in actor.shows {
            //let showFound = modelData.shows.first(where: { $0.id == showId })
            let showFound = modelData.showDict[showId]
            if (showFound != nil && showFound!.rating != nil) {
                sum += showFound!.rating!.pointValue
                count += 1
            }
        }
        var output: Double = Double(sum) / Double(count)
        return output
    }
    
    var actorRatingsGraph: some View {
        VStack {
            Text("Your Ratings")
                .font(.title)
            Text("Your average rating: \(avgRating)")
            ScrollView(.horizontal) {
                Chart {
                    ForEach(Rating.allCases.sorted {
                        ratingsCounts[$0] ?? 0 > ratingsCounts[$1] ?? 0
                    }) { rating in
                        BarMark(
                            x: .value("Rating", rating.rawValue),
                            y: .value("Count", ratingsCounts[rating]!)
                        )
                        .annotation(position: .top) {
                            Text(String(ratingsCounts[rating]!))
                        }
                        .foregroundStyle(by: .value("Rating", rating.rawValue))
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea.frame(height:250)
                }
                .padding(.top, 25)
            }
        }
    }
    */
    
}

/*
struct ActorDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            //ActorDetail(actorId: "zdvmjx5mhIZnjzTP6KlZ")
                //.environmentObject(modelData)
        }
    }
}
*/

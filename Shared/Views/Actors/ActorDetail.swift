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
    @ObservedObject var vm = ActorDetailViewModel()
        
    var actorId: String
    var actor: Actor? { modelData.actorDict[actorId] }
    
    @State var actorEdited: Actor = Actor(id: "1")
    
    @State private var isPresented = false // Edit menu var
    
    var loggedShows: [String: String] {
        if (actor == nil) { return [String:String]() }
        else { return actor!.shows.filter { modelData.showDict[$0.key] != nil && modelData.showDict[$0.key]!.addedToUserShows } }
    }
    
    var newShows: [String: String] { actor!.shows.filter { loggedShows[$0.key] == nil } }
    
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
                            
                            ForEach(loggedShows.sorted(by: >), id:\.key) { showId, showName in
                                NavigationLink(destination: ShowDetail(showId: showId)) {
                                    HStack {
                                        Text(showName)
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        VStack (alignment: .leading) {
                            Text("Other Shows \(loadedActor.name) has appeared in:")
                                .padding()
                            
                            ForEach(newShows.sorted(by: >), id:\.key) { showId, showName in
                                NavigationLink(destination: ShowDetail(showId: showId)) {
                                    HStack {
                                        Text(showName)
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        //actorTagsGraph
                        
                        //actorRatingsGraph
                        
                    }
                } else {
                    VStack {
                        Text("Loading Actor")
                    }
                }
            }
            .refreshable {
                vm.loadActor(modelData: modelData, id: actorId)
            }
            .task {
                vm.loadActor(modelData: modelData, id: actorId)
            }
        }
        
        .navigationTitle(actor?.name ?? "Loading Actor")
        .navigationBarTitleDisplayMode(.inline)
        //.navigationBarBackButtonHidden(false)
        
        .navigationBarItems(trailing: Button("Edit") {
            if (actor != nil) {
                actorEdited = actor!
                isPresented = true
            }
        })
        
        .sheet(isPresented: $isPresented) {
            NavigationView {
                ActorDetailEdit(isPresented: self.$isPresented, actor: $actorEdited)
                //ShowDetailEdit(isPresented: self.$isPresented)
                    .navigationTitle(actor!.name)
                    .navigationBarItems(leading: Button("Cancel") {
                        actorEdited = actor!
                        isPresented = false
                    }, trailing: Button("Done") {
                        //print(showEdited)
                        if (actorEdited != actor) {
                            if (actorEdited.name != actor!.name) {
                                updateActor(act: actorEdited, actorNameEdited: true)
                            } else {
                                updateActor(act: actorEdited, actorNameEdited: false)
                            }
                        }
                        isPresented = false
                    })
            }
        }
    }
    /*
    var tagCounts: [Tag: Int] {
        var output = [Tag: Int]()
        for tag in Tag.allCases {
            output[tag] = 0
        }
        for (showId, showName) in actor.shows {
            //let showFound = modelData.shows.first(where: { $0.id == showId })
            let showFound = modelData.showDict[showId]
            if (showFound != nil && showFound!.tags != nil) {
                for showTag in showFound!.tags! {
                    output[showTag]! += 1
                }
            }
        }
        return output
    }
    
    var actorTagsGraph: some View {
        VStack {
            Text("Tags")
            ScrollView(.horizontal) {
                Chart {
                    ForEach(Tag.allCases.sorted {
                        tagCounts[$0] ?? 0 > tagCounts[$1] ?? 0
                    }) { tag in
                        BarMark(
                            x: .value("Tag", tag.rawValue),
                            y: .value("Count", tagCounts[tag]!)
                        )
                        .annotation(position: .top) {
                            Text(String(tagCounts[tag]!))
                        }
                        .foregroundStyle(by: .value("Tag", tag.rawValue))
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea.frame(height:250)
                }
                .padding(.top, 25)
            }
        }
    }
    
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

struct ActorDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            //ActorDetail(actorId: "zdvmjx5mhIZnjzTP6KlZ")
                //.environmentObject(modelData)
        }
    }
}

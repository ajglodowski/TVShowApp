//
//  ShowSeasonsRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 6/4/22.
//

import SwiftUI
import Firebase

struct ShowSeasonsRow: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var userId: String? { modelData.currentUser?.id }
    
    var backgroundColor: Color
    var showId: Int
    
    var userData: ShowUserSpecificDetails? {
        modelData.showDict[showId]?.userSpecificValues
    }
    var totalSeasons: Int { modelData.showDict[showId]?.totalSeasons ?? 0 }
    var currentSeason: Int? { userData?.currentSeason }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Seasons:")
                .font(.title)
                .padding(.top, 10)
            ScrollView(.horizontal) {
                HStack (alignment: .top) {
                    ForEach(1..<totalSeasons+1, id:\.self) { num in
                        if (num != currentSeason ?? -1) {
                            VStack (alignment: .center) {
                                Button(action: {
                                    if (userId != nil) {
                                        Task {
                                            let success = await updateUserShowData(updateType: UserUpdateCategory.ChangedSeason, userId: userId!, showId: showId, seasonChange: num, ratingChange: nil, statusChange: nil)
                                            if (success) {
                                                modelData.showDict[showId]?.userSpecificValues?.currentSeason = num
                                            }
                                        }
                                    }
                                }, label: {
                                    Text((String(num)))
                                        .font(.title)
                                })
                                    .foregroundColor(Color.white)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .padding(2)
                            }
                            .frame(width: 50, height: 50, alignment: .top)
                        } else {
                            VStack {
                                Text(String(num))
                                    .font(.title)
                                    .foregroundColor(Color.black)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background(.white)
                                    .cornerRadius(10)
                                Text("Current Season")
                                    .font(.headline)
                                    .fixedSize()
                            }
                            .frame(width: 50, height: 50, alignment: .top)
                            
                        }
                    }
                    // Plus button
                    VStack {
                        Button(action: {
                            //incrementTotalSeasons(showId: showId)
                        }) {
                            Image(systemName: "plus")
                        }
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(.green)
                        .cornerRadius(10)
                    }
                    .frame(width: 50, height: 50, alignment: .top)
                    
                }
            .padding(.bottom, 40)
            .padding(.leading, 40)
            //.padding(.trailing, 40)
            }
        }
    }
}

/*
struct ShowSeasonsRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShowSeasonsRow(totalSeasons: 5, currentSeason: .constant(3), backgroundColor: Color.black, showIndex: 0)
        }
    }
}
*/

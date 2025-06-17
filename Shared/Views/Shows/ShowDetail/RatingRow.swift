//
//  RatingRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/23/22.
//

import SwiftUI
import Firebase

struct RatingRow: View {
    
    var curRating: Rating
    @EnvironmentObject var modelData: ModelData
    var showId: Int
    var uid: String? { modelData.currentUser?.id }
    
    var body: some View {
        VStack {
            HStack (alignment:.top) {
                ForEach(Rating.allCases) { rating in
                    Button(action: {
                        Task {
                            if (uid != nil) {
                                let success = await updateUserShowData(updateType: UserUpdateCategory.ChangedRating, userId: uid!, showId: showId, seasonChange: nil, ratingChange: rating, statusChange: nil)
                                if (success) {
                                    await modelData.reloadAllShowData(showId: showId, userId: uid)
                                }
                            }
                        }
                    }) {
                        VStack() {
                            Image(systemName: (curRating == rating) ? (rating.ratingSymbol+".fill") : rating.ratingSymbol)
                                .resizable()
                                .scaledToFill()
                                .frame(width:25, height:25)
                            if (curRating == rating) {
                                Text(rating.rawValue)
                            }
                        }
                        
                    }
                }
            }
            .foregroundColor(Color.white)
            Button(action: {
                Task {
                    if (uid != nil) {
                        let success = await updateUserShowData(updateType: UserUpdateCategory.RemovedRating, userId: uid!, showId: showId, seasonChange: nil, ratingChange: nil, statusChange: nil)
                        if (success) {
                            await modelData.reloadAllShowData(showId: showId, userId: uid)
                        }
                    }
                }
            }) {
                Text("Remove Rating")
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
    }
}

/*
struct RatingRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            //RatingRow(curRating: nil)
            RatingRow(curRating: .constant(Rating.Disliked))
            RatingRow(curRating: .constant(Rating.Meh))
            RatingRow(curRating: .constant(Rating.Liked))
            RatingRow(curRating: .constant(Rating.Loved))
        }
        
    }
}
*/

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
    var show: Show
    
    var body: some View {
        VStack {
            HStack (alignment:.top) {
                ForEach(Rating.allCases) { rating in
                    Button(action: {
                        decrementRatingCount(showId: show.id, rating: show.userSpecificValues!.rating!)
                        updateRating(rating: rating, showId: show.id)
                        addUserUpdateRatingChange(userId: Auth.auth().currentUser!.uid, show: show, rating: rating)
                        incrementRatingCount(showId: show.id, rating: rating)
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
                decrementRatingCount(showId: show.id, rating: show.userSpecificValues!.rating!)
                deleteRatingFromUserShows(showId: show.id)
                addUserUpdateRatingRemoval(userId: Auth.auth().currentUser!.uid, show: show)
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

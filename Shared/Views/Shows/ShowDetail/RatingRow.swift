//
//  RatingRow.swift
//  TV Show App
//
//  Created by AJ Glodowski on 7/23/22.
//

import SwiftUI

struct RatingRow: View {
    
    @Binding var curRating: Rating?
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        //ScrollView (.horizontal) {
            HStack (alignment:.top) {
                ForEach(Rating.allCases) { rating in
                    Button(action: {
                        curRating = rating
                    }) {
                        VStack() {
                            Image(systemName: (curRating == rating) ? (getRatingSymbol(rating: rating)+".fill") : getRatingSymbol(rating: rating))
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
            //.padding(5)
            //.background(.quaternary)
            //.cornerRadius(5)
        }
    //}
}

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

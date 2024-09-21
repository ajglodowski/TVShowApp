//
//  RatingSection.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/24/24.
//

import SwiftUI

struct RatingSection: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var show: Show
    var uid: String? { modelData.currentUser?.id }
    
    var body: some View {
        HStack {
            if (show.addedToUserShows && show.userSpecificValues!.rating != nil) { RatingRow(curRating: show.userSpecificValues!.rating!, showId: show.id)
            } else if (show.addedToUserShows) {
                Button(action: {
                    Task {
                        if (uid != nil) {
                            let success = await updateUserShowData(updateType: UserUpdateCategory.ChangedRating, userId: uid!, showId: show.id, seasonChange: nil, ratingChange: Rating.Meh, statusChange: nil)
                            if (success) {
                                await modelData.reloadAllShowData(showId: show.id, userId: uid)
                            }
                        }
                    }
                }) {
                    Text("Add a rating")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    RatingSection(show: Show(from: MockSupabaseShow))
        .environmentObject(ModelData())
}

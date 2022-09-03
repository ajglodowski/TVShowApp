//
//  RatingGraphs.swift
//  TV Show App
//
//  Created by AJ Glodowski on 9/2/22.
//

import SwiftUI

struct RatingGraphs: View {
    
    @State var selectedView: Int = 0
    
    var body: some View {
        VStack {
            Picker("Length", selection: $selectedView) {
                Text("Your Ratings").tag(0)
                Text("Average Ratings").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        
        if (selectedView == 0) {
            PersonalRatingGraphs()
        } else {
            AverageRatingsGraphs()
        }
    }
}

struct RatingGraphs_Previews: PreviewProvider {
    static var previews: some View {
        RatingGraphs()
    }
}

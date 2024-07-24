//
//  MigrationView.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/14/24.
//

import SwiftUI

struct MigrationView: View {
    
    @EnvironmentObject var modelData : ModelData
    
    var updates: [TagCategory] { modelData.tagCategories }
    
    var body: some View {

        List {
            /*
            ForEach(fetched) { userDetail in
                Text(String(userDetail.showId))
            }
             */
            ForEach(updates) { update in
                Text(update.name)
            }
        }
    }
}

#Preview {
    return MigrationView()
        .environmentObject(ModelData())
}

//
//  UpdateLogSection.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/2/23.
//

import SwiftUI

struct UpdateLogSection: View {
    var show: Show
    var count: Int {
        let updates = show.currentUserUpdates ?? [UserUpdate]()
        print(updates.count)
        return updates.count
    }
    var body: some View {
        VStack (alignment: .leading) {
            Text("Your updates for this show")
                .font(.headline)
            UpdateLog(updates: show.currentUserUpdates?.sorted { $0.updateDate < $1.updateDate } ?? [UserUpdate]())
        }
    }
}

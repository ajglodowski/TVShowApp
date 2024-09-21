//
//  UserUpdateRow.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/11/24.
//

import SwiftUI

struct UserUpdateRow: View {
    var updates: [UserUpdate]
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach (updates) { update in
                    NavigationLink(destination: ShowDetail(showId: update.showId)) {
                        UserUpdateCard(update: update)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

#Preview {
    UserUpdateRow(updates: [])
}

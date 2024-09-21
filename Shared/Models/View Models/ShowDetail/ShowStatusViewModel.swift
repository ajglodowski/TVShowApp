//
//  ShowStatusViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/24/24.
//

import Foundation
class ShowStatusViewModel: ObservableObject {
    
    @Published var statusCounts: [Status:Int]? = nil
    
    @MainActor
    func setStatusCounts(counts: [Status:Int]) {
        self.statusCounts = counts
    }
    
    func loadStatusCounts(showId: Int) async {
        let counts = await getStatusCountsForShow(showId: showId)
        await setStatusCounts(counts: counts)
    }
    
}

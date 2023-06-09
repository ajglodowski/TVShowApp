//
//  LastUserFetch.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/8/23.
//

import Foundation
import SwiftData

@Model
class LastUserFetch: Hashable {
    var fetchDate: Date
    init(fetchDate: Date) {
        self.fetchDate = fetchDate
    }
}

@MainActor func updateFetchDate(newFetch: Date)  {
    let container = try! ModelContainer(for: LastUserFetch.self)
    let context = container.mainContext
    let previousData = try! context.fetch(FetchDescriptor<LastUserFetch>())
    if previousData.contains(where: { $0.fetchDate >= newFetch}) {
        print("Tried updating latest fetch but found later fetch date in memory.")
        return
    }
    for previousEntry in previousData {
        context.delete(previousEntry)
    }
    context.insert(LastUserFetch(fetchDate: newFetch))
    try! context.save()
}

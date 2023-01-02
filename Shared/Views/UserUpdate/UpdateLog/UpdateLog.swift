//
//  UpdateLog.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/2/23.
//

import SwiftUI

struct UpdateLog: View {
    
    var updates: [UserUpdate]
    var middleUpdates: [UserUpdate] {
        var out = updates
        out.removeFirst()
        out.removeLast()
        return out
    }
    
    var body: some View {
        VStack {
            switch updates.count {
            case 0:
                Text("No updates for this show")
            case 1:
                singleUpdate
            case 2:
                twoUpdates
            default:
                manyUpdates
            }
        }
    }
    
    
    var singleUpdate: some View {
        VStack (alignment: .leading) {
            UpdateLogNode(nodeType: UpdateLogNodeType.single, update: updates[0])
        }
    }
    
    var twoUpdates: some View {
        VStack (alignment: .leading, spacing: 0) {
            UpdateLogNode(nodeType: UpdateLogNodeType.start, update: updates[0])
            UpdateLogNode(nodeType: UpdateLogNodeType.end, update: updates[1])
        }
    }
    
    var manyUpdates: some View {
        VStack (alignment: .leading, spacing: 0) {
            UpdateLogNode(nodeType: UpdateLogNodeType.start, update: updates[0])
            ForEach (middleUpdates) { update in
                UpdateLogNode(nodeType: UpdateLogNodeType.middle, update: update)
            }
            UpdateLogNode(nodeType: UpdateLogNodeType.end, update: updates[updates.count-1])
        }
    }
    
}

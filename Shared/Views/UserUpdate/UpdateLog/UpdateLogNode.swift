//
//  UpdateLogNode.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/2/23.
//

import SwiftUI

enum UpdateLogNodeType {
    case single
    case start
    case middle
    case end
}

struct UpdateLogNode: View {
    
    var nodeType: UpdateLogNodeType
    var update: UserUpdate
    
    var dateString: String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        df.dateStyle = .short
        return df.string(from: update.updateDate)
    }
    
    var body: some View {
        HStack {
            VStack {
                switch nodeType {
                case .single:
                    Circle()
                        .fill(.white)
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                case .start:
                    bottomLine
                case .middle:
                    middleLine
                case .end:
                    topLine
                }
            }
            HStack {
                Text(update.updateMessage)
                Spacer()
                Text(dateString)
                    .font(.footnote)
            }
        }
    }
    
    var bottomLine: some View {
        ZStack(alignment:.center) {
            Circle()
                .fill(.white)
                .scaledToFit()
                .frame(width: 10, height: 10)
            Color.white.frame(width: 2)
                .offset(y: 5)
        }
    }
    
    var middleLine: some View {
        ZStack(alignment:.center) {
            Circle()
                .fill(.white)
                .scaledToFit()
                .frame(width: 10, height: 10)
            Color.white.frame(width: 2)
        }
    }
    
    var topLine: some View {
        ZStack(alignment:.center) {
            Circle()
                .fill(.white)
                .scaledToFit()
                .frame(width: 10, height: 10)
            Color.white.frame(width: 2)
                .offset(y: -5)
        }
    }
    
    
}

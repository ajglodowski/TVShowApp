//
//  ServiceBubble.swift
//  TV Show App
//
//  Created by AJ Glodowski on 2/4/23.
//

import SwiftUI

struct ServiceBubble: View {
    
    var service: Service
    
    var body: some View {
        Text(service.rawValue)
            .padding(6)
            .font(.callout)
            .foregroundColor(.white)
            .background(Capsule().fill(service.color))
    }
}

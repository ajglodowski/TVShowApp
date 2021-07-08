//
//  TileBanner.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/2/21.
//

import SwiftUI

struct TileBanner: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            //.padding(.vertical, 5)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 5)
            .background(Color.secondary)
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

struct TileBanner_Previews: PreviewProvider {
    static var previews: some View {
        TileBanner(text: "Test Banner")
    }
}

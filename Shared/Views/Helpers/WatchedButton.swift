//
//  WatchedButton.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/28/21.
//

import SwiftUI

struct WatchedButton: View {
    
    @Binding var isSet: Bool
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        Button(action: {
            isSet.toggle()
            //ModelData().write()
        }) {
            Image(systemName: isSet ? "eye.fill" : "eye")
                .foregroundColor(isSet ? Color.blue : Color.white)
            if (isSet) {
                Text("Watched")
            }
        }
        
    }
}

struct WatchedButton_Previews: PreviewProvider {
    static var previews: some View {
        WatchedButton(isSet: .constant(false))
    }
}

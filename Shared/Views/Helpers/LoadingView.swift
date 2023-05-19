//
//  LoadingView.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 5/19/23.
//

import SwiftUI

struct LoadingView: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View {
        VStack {
            ZStack {
                //Color.black.opacity(0.3)
                
                Color.white
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(gradient: .init(colors: [.clear,Color.white.opacity(0.5),.clear]), startPoint: .top, endPoint: .bottom)
                            )
                            .scaleEffect(2)
                            .rotationEffect(.init(degrees: 70))
                            .offset(x: self.show ? center : -center)
                    )
            }
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(Animation.default.speed(0.1).repeatForever(autoreverses: true)) {
                        self.show.toggle()
                    }
                }
                
            }
        }
        .background(.quaternary)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

//
//  ShowDetail.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import SwiftUI
import Combine


struct ShowDetail: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var show : Show
    
    @State private var isPresented = false
    
    var showIndex: Int {
        modelData.shows.firstIndex(where: { $0.id == show.id })!
    }
    
    var body: some View {
        
        //ContentView.navigationBar.navigationBarHidden(true)
        
        VStack {
            
            Image(show.name)
                .resizable()
                .cornerRadius(20)
                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .scaledToFit()            
            VStack (alignment: .leading) {
                HStack {
                    Text(show.name)
                        .font(.title)
                    
                    //Button(action: show.watched.toggle, label:)
                    
                    WatchedButton(isSet: $modelData.shows[showIndex].watched)
                }
                
                HStack {
                    Text("Show Length: " + show.length.rawValue + " minutes")
                        .font(.subheadline)
                    Spacer()
                    Text(show.service.rawValue)
                        .font(.subheadline)
                }
                Text("Status: " + show.status)
                    .font(.subheadline)
                
                Divider()
                Text("About Show")
                
            }
            .padding()
            .navigationTitle(show.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            
            .navigationBarItems(trailing: Button("Edit") {
                        isPresented = true
                    })
            
            .sheet(isPresented: $isPresented) {
                        NavigationView {
                            ShowDetailEdit(show: show)
                                .navigationTitle(show.name)
                                .navigationBarItems(trailing: Button("Done") {
                                    isPresented = false
                                })
                        }
                    }
            
            /*
            .toolbar{
                NavigationLink("Edit", destination: ShowDetail(show: show))
            }
             */
        }
        .ignoresSafeArea()
    }
}

struct ShowDetail_Previews: PreviewProvider {
    
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ShowDetail(show: modelData.shows[30])
                .environmentObject(modelData)
        }
    }
}

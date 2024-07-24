//
//  ShowListViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import Foundation
import Swift
import SwiftUI
import Firebase

class ShowListViewModel: ObservableObject {
    
    @Published var showListObj: ShowList? = nil
    
    //private var ref: DatabaseReference = Database.database().reference()
    //private var fireStore = Firebase.Firestore.firestore()

    func fetchList(id: Int, showLimit: Int? = nil) async -> SupabaseShowList {
        do {
            let fetchedList = try await supabase
                .from("showList")
                .select(SupabaseShowListProperties)
                .match(["id": id])
                .single()
                .execute()
                .value
        } catch {
            
        }
    }
    
    @MainActor
    func loadList(id: Int, showLimit: Int? = nil) async {
        
    }
}

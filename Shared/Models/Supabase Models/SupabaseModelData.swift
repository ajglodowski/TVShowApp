//
//  SupabaseModelData.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/14/24.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import PostgREST

@MainActor final class SupbaseModelData : ObservableObject {
    
    //@Published var loadedShow: Show? = nil
    
    //@Published var entered: Bool = false

    var shows: [Show] { Array(showDict.values) }
    @Published var showDict = [Int:Show]()
    @Published var loadingShows: Set<String> = Set<String>()
    @Published var userShowDetails: [SupabaseShowUserDetails] = []
    
    var loggedIn: Bool { supabase.auth.currentUser != nil }
    @Published var currentUser: Profile? = nil
    
    init() {
        if (loggedIn) {
            Task {
                await loadCurrentUser()
                await loadFromSupabase()
            }
        } else {
            print("Not logged in")
        }
    }
    
    func loadCurrentUser() async {
        currentUser = Profile(from: MockSupabaseProfile)
    }
    
    func loadFromSupabase() async {
        await loadUsersShows()
    }
    
    func dumpInfo() async {
        print("Dumping")
        //dump(shows)
    }
    
    func convertIds(input: [Int]) -> String {
        var out = "("
        for i in input {
            out += "\(i),"
        }
        out.removeLast()
        out += ")"
        return out
    }
    
    
    func loadUsersShows() async {
        
        if (currentUser != nil) {
            do {
                let fetchedDetails: [SupabaseShowUserDetails] = try await supabase
                    .from("UserShowDetails")
                    .select(SupabaseShowUserDetailsProperties)
                    .eq("userId", value: currentUser!.id)
                    .execute()
                    .value
                userShowDetails = fetchedDetails
            } catch {
                dump(error)
            }
            
            do {
                let showIds: [Int] = userShowDetails.map { Int($0.showId) }
                let fetchedShows: [SupabaseShow] = try await supabase
                    .from("show")
                    .select(SupabaseShowProperties)
                    .in("id", values: showIds)
                    .execute()
                    .value
                
                for show in fetchedShows {
                    var showObj = Show(from: show)
                    let supabaseDetail = userShowDetails.first(where: { $0.showId == show.id })
                    let detailsObj = ShowUserSpecificDetails(from: supabaseDetail!)
                    showObj.userSpecificValues = detailsObj
                    showDict[show.id] = showObj
                }
            } catch {
                dump(error)
            }
             
        }
         
    }
    
    
}


//
//  ModelData.swift
//  TV Show App
//
//  Created by AJ Glodowski on 4/27/21.
//

import Foundation
import Combine
import SwiftUI
import Firebase

final class ModelData : ObservableObject {
    
    var shows: [Show] { Array(showDict.values) }
    @Published var showDict = [Int:Show]()
    @Published var loadingShows: Set<Int> = Set<Int>()
    @Published var fullShowImages: [Int:UIImage] = [Int:UIImage]()
    @Published var userShowDetails: [SupabaseShowUserDetails] = []
    var actors: [Actor] {
        var actorDict = [Int:Actor]()
        let filtered = self.shows.filter { $0.addedToUserShows }
        for show in filtered {
            if (show.actors != nil) {
                for (actorId, actor) in show.actors! {
                    if (actorDict[actorId] == nil) {
                        actorDict[actorId] = actor
                    }
                }
            }
        }
        return Array(actorDict.values)
    }
    
    @Published var currentUser: Profile? = nil
    
    @Published var updateDict = [Int:UserUpdate]()
    var currentUserUpdates: [UserUpdate] {
        if (currentUser != nil) { return Array(updateDict.values).filter { $0.userId == currentUser!.id } }
        else { return [UserUpdate]() }
    }
    
    var lastFriendUpdates: [UserUpdate] = []
    /*
    var lastFriendUpdates: [UserUpdate] {
        var output = [UserUpdate]()
        if (currentUser != nil) {
            let allFriendUpdates = Array(updateDict.values).filter { $0.userId != Auth.auth().currentUser!.uid }.sorted{ $0.updateDate > $1.updateDate }.sorted{ $0.userId < $1.userId }
            let friends = Array(Set(allFriendUpdates.map { $0.userId }))
            for friend in friends {
                output.append(allFriendUpdates.first(where: { $0.userId == friend })!)
            }
        }
        return output
    }
     */
    @Published var tileImageCache: [String: Image] = [String: Image]()
    
    @Published var profiles: [String: Profile] = [String: Profile]()
    @Published var profilePics: [String: Image] = [String: Image]()
    @Published var loadingProfiles: Set<String> = Set<String>()
    
    var loggedIn: Bool { supabase.auth.currentUser != nil }
    
    var showIds: [Int] {
        shows.map { $0.id }
    }
    
    @Published var tagCategories: [TagCategory] = []
    @Published var tags: [Tag] = []
    @Published var statuses: [Status] = []
    @Published var services: [SupabaseService] = []
    
    init() {
        Task {
            await loadEverything()
        }
    }
    
    @MainActor
    func updateShowDict(shows: [Show]) {
        for show in shows {
            self.showDict[show.id] = show
        }
    }
    
    @MainActor
    func updateShow(show: Show) {
        showDict[show.id] = show
    }
    
    @MainActor
    func setTags(tags: [Tag]) {
        self.tags = tags
    }
    
    @MainActor
    func setTagCategories(categories: [TagCategory]) {
        self.tagCategories = categories
    }
    
    @MainActor
    func setStatuses(statuses: [Status]) {
        self.statuses = statuses
    }
    
    @MainActor
    func setServices(services: [SupabaseService]) {
        self.services = services
    }
    
    @MainActor
    func setUserUpdate(update: UserUpdate) {
        self.updateDict[update.id] = update
    }
    
    @MainActor
    func updateUserUpdates(updates: [UserUpdate]) {
        for update in updates {
            self.updateDict[update.id] = update
        }
    }
    
    @MainActor
    func updateShowsTags(showId: Int, tags: [Tag]) {
        if (self.showDict[showId] != nil) {
            self.showDict[showId]!.tags = tags
        }
    }
    
    @MainActor
    func updateShowsActors(showId: Int, tags: [Tag]) {
        if (self.showDict[showId] != nil) {
            if (self.showDict[showId]!.actors != nil) {
                self.showDict[showId]!.tags = tags
            }
        }
    }
    
    func reloadAllShowData(showId: Int, userId: String?) async {
        async let showData = reloadShowData(showId: showId, userId: userId)
        async let userUpdates = loadUserUpdates(showId: showId, userId: userId)
        async let tags = refreshShowsTags(showId: showId)
        await (showData, userUpdates, tags)
    }
    
    func reloadShowData(showId: Int, userId: String?) async {
        let userData = await getUserShowData(showId: showId, userId: userId)
        let showData = await getShow(showId: showId)
        if (showData == nil) { return }
        var combinedShow = showData!
        combinedShow.userSpecificValues = userData
        await updateShow(show: combinedShow)
    }
    
    func loadUserUpdates(showId: Int, userId: String?) async {
        let updates = await getUserUpdates(showId: showId, userId: userId);
        await updateUserUpdates(updates: updates)
    }

    
    func loadEverything() async {
        await loadBaseData()
        if (loggedIn) {
            await loadCurrentUser()
            async let loadingShowDataTask = loadShowInfo()
            async let loadingUpdatesTaks = loadCurrentUserUpdates()
            await (loadingShowDataTask, loadingUpdatesTaks)
        } else {
            print("Not logged in")
        }
    }
    
    func loadShowInfo() async {
        await loadFromSupabase()
        await fillInTagsForShows()
        //await fillInActorsForShows()
    }
    
    func loadBaseData() async {
        async let loadingTagCategories = loadTagCategories()
        async let loadingTags = loadTags()
        async let loadingStatuses = loadStatuses()
        async let loadingServices = loadServices()
        await (loadingTagCategories, loadingTags, loadingStatuses, loadingServices)
    }
    
    func loadTags() async {
        do {
            let fetchedTags: [Tag] = try await supabase
                .from("showTag")
                .select(TagProperties)
                .execute()
                .value
            await setTags(tags: fetchedTags)
        } catch {
            dump(error)
        }
    }
    
    func loadTagCategories() async {
        do {
            let fetchedCategories: [TagCategory] = try await supabase
                .from("ShowTagCategory")
                .select(TagCategoryProperties)
                .execute()
                .value
            await setTagCategories(categories: fetchedCategories)
        } catch {
            dump(error)
        }
    }
    
    func loadStatuses() async {
        do {
            let fetchedStatuses: [Status] = try await supabase
                .from("status")
                .select(StatusProperties)
                .execute()
                .value
            await setStatuses(statuses: fetchedStatuses)
        } catch {
            dump(error)
        }
    }
    
    func loadServices() async {
        do {
            let fetchedServices: [SupabaseService] = try await supabase
                .from("service")
                .select(SupabaseServiceProperties)
                .execute()
                .value
            await setServices(services: fetchedServices)
        } catch {
            dump(error)
        }
    }
    
    @MainActor
    func loadCurrentUser() async {
        if (loggedIn) {
            do {
                let fetchedProfile: SupabaseProfile = try await supabase
                    .from("user")
                    .select(SupabaseProfileProperties)
                    .eq("id", value: supabase.auth.currentUser!.id)
                    .single()
                    .execute()
                    .value
                let prof = Profile(from: fetchedProfile)
                currentUser = prof
                profiles[prof.id] = prof
            } catch {
                dump(error)
            }
        }
    }
    
    func loadCurrentUserUpdates() async {
        if (currentUser != nil) {
            do {
                let fetchedDetails: [SupabaseUserUpdate] = try await supabase
                    .from("UserUpdate")
                    .select(SupabasUserUpdateProperties)
                    .eq("userId", value: currentUser!.id)
                    .execute()
                    .value
                let convertedDetails = fetchedDetails.map { UserUpdate(from: $0) }
                await updateUserUpdates(updates: convertedDetails)
            } catch {
                dump(error)
            }
        }
    }
    
    func loadFromSupabase() async {
        await loadUsersShows()
    }
    
    func fetchAllActorsForShows(showList: [Int]) async -> [Int:[Actor]] {
        await withTaskGroup(of: (Int, [Actor]).self) { taskGroup in
            for key in showList {
                taskGroup.addTask {
                    let actors = await getActorsForShow(showId: key)
                    return (key, actors)
                }
            }
            
            var actorDict = [Int: [Actor]]()
            
            for await (key, actors) in taskGroup {
                actorDict[key] = actors
            }
            
            return actorDict
        }
    }
    
    
    
    func fetchAllTagsForShows(showList: [Int]) async -> [Int:[Tag]] {
        await withTaskGroup(of: (Int, [Tag]).self) { taskGroup in
            for key in showList {
                taskGroup.addTask {
                    let tags = await getTagsForShow(showId: key)
                    return (key, tags)
                }
            }
            
            var tagDict = [Int: [Tag]]()
            
            for await (key, tags) in taskGroup {
                tagDict[key] = tags
            }
            
            return tagDict
        }
    }
    
    @MainActor
    func updateShowTags(showDict: [Int:[Tag]]) {
        for (key,value) in showDict {
            if (self.showDict[key] != nil) {
                self.showDict[key]!.tags = value
            }
        }
    }
    
    @MainActor
    func updateShowActors(showDict: [Int:[Actor]]) {
        for (key,value) in showDict {
            if (self.showDict[key] != nil) {
                if (self.showDict[key]!.actors == nil) {
                    self.showDict[key]!.actors = [Int:Actor]()
                }
                for act in value {
                    self.showDict[key]!.actors![act.id] = act
                }
            }
        }
    }
    
    
    @MainActor
    func updateSingleShowsTags(showId: Int, tags: [Tag]) {
        if (self.showDict[showId] != nil) {
            self.showDict[showId]!.tags = tags
        }
    }

    func refreshShowsTags(showId: Int) async {
        let tags = await getTagsForShow(showId: showId)
        await updateSingleShowsTags(showId: showId, tags: tags)
    }
    
    func fillInTagsForShows() async {
        let tagDict = await fetchAllTagsForShows(showList: Array(self.showDict.keys))
        await updateShowTags(showDict: tagDict)
    }
    
    func fillInActorsForShows() async {
        let actorDict = await fetchAllActorsForShows(showList: Array(self.showDict.keys))
        await updateShowActors(showDict: actorDict)
    }
        
    
    func loadUsersShows() async {
        if (currentUser != nil) {
            var fetchedDetails: [SupabaseShowUserDetails] = []
            do {
                fetchedDetails = try await supabase
                    .from("UserShowDetails")
                    .select(SupabaseShowUserDetailsProperties)
                    .eq("userId", value: currentUser!.id)
                    .execute()
                    .value
            } catch {
                dump(error)
                return
            }
            
            do {
                let showIds: [Int] = fetchedDetails.map { Int($0.showId) }
                let fetchedShows: [SupabaseShow] = try await supabase
                    .from("show")
                    .select(SupabaseShowProperties)
                    .in("id", values: showIds)
                    .execute()
                    .value
                var convertedShows: [Show] = []
                for show in fetchedShows {
                    var showObj = Show(from: show)
                    let supabaseDetail = fetchedDetails.first(where: { $0.showId == show.id })
                    let detailsObj = ShowUserSpecificDetails(from: supabaseDetail!)
                    showObj.userSpecificValues = detailsObj
                    convertedShows.append(showObj)
                }
                await updateShowDict(shows: convertedShows)
            } catch {
                dump(error)
            }
             
        }
         
    }
    
     /*
    func loadLatestFriendUpdates() {
        if (self.currentUser == nil) { print("User null") }
        let friends = Array(self.currentUser!.following.map { $0.keys }!)
        for friend in friends {
            let updates = fireStore.collection("updates").whereField("userId", isEqualTo: friend).order(by: "updateDate", descending: true).limit(to: 1)
            updates.addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let updateId = document.documentID
                        //if (self.lastFriendUpdates.contains(where: {$0.id == updateId})) { continue } // prevent double appending
                        let data = document.data()
                        let update = convertDataDictToUserUpdate(updateId: updateId, data: data)
                        //self.lastFriendUpdates.append(update)
                        self.updateDict[updateId] = update
                    }
                }
            }
        }
        
    }
     */
    
}



extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

public extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

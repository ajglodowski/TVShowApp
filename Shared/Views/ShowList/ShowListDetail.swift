//
//  List.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 9/21/22.
//

import SwiftUI

struct ShowListDetail: View {
    
    var listId: Int
    
    var body: some View {
        Text("Todo")
    }
    
    /*
    
    @EnvironmentObject var modelData : ModelData
    @StateObject var listVm = ShowListViewModel()
    @StateObject var profileVm = ProfileViewModel()
    
    @State private var editPresented = false
    @State var listEdited = ShowList(id: "1", name: "Temp Show", description: "", shows: [], ordered: false, priv: false, profile: Profile(id: "1", username: "", pinnedShowCount: 0, showCount: 0, followingCount: 0, followerCount: 0), likeCount: 0)
    
    @State var listObj: ShowList? = nil
    
    func reloadData() async {
        await listVm.loadList(modelData: modelData, id: listId)
        self.listObj = listVm.showListObj
    }
    
    var listShows: [Show] {
        var output = [Show]()
        if (listObj == nil) { return output }
        listObj!.shows.forEach { show in
            if (modelData.showDict[show] != nil) {
                output.append(modelData.showDict[show]!)
            }
        }
        return output
    }
    
    var likedByCurrentUser: Bool {
        if (listObj != nil &&
            modelData.currentUser != nil &&
            modelData.currentUser!.likedShowLists != nil &&
            modelData.currentUser!.likedShowLists!.contains(listObj!.id)) {
            return true
        } else {
            return false
        }
    }
    
    var ownedList: Bool {
        if (listObj != nil &&
            modelData.currentUser != nil &&
            listObj!.profile.id == modelData.currentUser!.id) {
            return true
        } else {
            return false
        }
    }
    
    @State var searchText: String = ""
    
    var displayedShows: [Show] {
        if (listShows.isEmpty) { return listShows }
        if (!searchText.isEmpty) {
            return listShows.filter { $0.name.contains(searchText) }
        } else {
            return listShows
        }
    }
    
    var body: some View {
        
        List {
            if (listObj != nil) {
                //
                
                if (searchText.isEmpty) {
                    header
                    
                    ProfileTile(profileId: (listObj?.profile.id)!)
                    
                    editRow
                }
                
                //showSection
                
                if (editing) {
                    showSearch
                }
                
                HStack {
                    Text("Show Name")
                    Spacer()
                    Text("Your Rating")
                }
                
                
                if (!editing) {
                    ForEach(Array(displayedShows.enumerated()), id: \.offset) { showPlace, show in
                        //NavigationLink(destination: ShowDetail(showId: show.id, show: show)) {
                        NavigationLink(destination: ShowDetail(showId: show.id)) {
                            HStack {
                                if (listObj!.ordered && searchText.isEmpty) {
                                    Text("\(showPlace+1).")
                                }
                                ListShowRow(show: show)
                            }
                        }
                    }
                    //.searchable(text: $searchText)
                } else {
                    ForEach(editingShows) { show in
                        HStack {
                            ListShowRow(show: show)
                            Button(action: {
                                editingShows.removeAll(where: { $0 == show})
                            }) {
                                Text("Remove from List")
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                    .onMove(perform: move)
                }
                
            }
        }
        .listStyle(.plain)
        .navigationTitle(listObj?.name ?? "Loading List")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            // Refresh here
            await reloadData()
        }
        .task {
            // Load here
            await reloadData()
        }
        .sheet(isPresented: $editPresented) {
            NavigationView {
                ShowListDetailEdit(showList: $listEdited, isPresented: self.$editPresented)
                    .navigationTitle(listObj?.name ?? "Loading List")
                    .navigationBarItems(leading: Button("Cancel") {
                        listEdited = listObj!
                        editPresented = false
                    }, trailing: Button("Done") {
                        if (listEdited != listObj!) {
                            // Update firebase
                            //updateList(list: listEdited)
                            Task {
                                await reloadData()
                            }
                        }
                        editPresented = false
                    })
            }
        }
    }
    
    var header: some View {
        VStack(alignment:.leading) {
            let listObj = listVm.showListObj
            if (listObj != nil) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(listObj!.name)
                            .font(.title)
                        // Public private toggle
                        if (ownedList) {
                            if (listObj!.priv) {
                                Button(action: {
                                    //makeListPublic(listId: listObj!.id)
                                    Task {
                                        await reloadData()
                                    }
                                }) {
                                    Text("Private List")
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Button(action: {
                                    //makeListPrivate(listId: listObj!.id)
                                    Task {
                                        await reloadData()
                                    }
                                }) {
                                    Text("Public List")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        Spacer()
                        if (ownedList) {
                            Button(action: {
                                listEdited = listObj!
                                editPresented = true
                            }) {
                                Text("Edit List")
                            }
                            .buttonStyle(.bordered)
                        }
                        
                    }
                    Text(listObj!.description)
                    HStack {
                        Text("\(listObj!.likeCount) likes")
                        Button(action: {
                            if (likedByCurrentUser) {
                                //dislikeList(listId: listObj!.id)
                                Task {
                                    await reloadData()
                                }
                            } else {
                                //likeList(listId: listObj!.id)
                                Task {
                                    await reloadData()
                                }
                            }
                        }) {
                            if (likedByCurrentUser) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.pink)
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "heart")
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    /*
                    NavigationLink(destination: ProfileDetail(id: listObj!.profile.id)) {
                        Text("List Creator: @\(listObj!.profile.username)")
                            .italic()
                            //.padding(5)
                            //.background(.tertiary)
                            //.cornerRadius(5)
                    }
                    .buttonStyle(.bordered)
                     */
                }
            }
        }
        .padding()
    }
    
    @State var editing: Bool = false
    @State var editingShows: [Show] = [Show]()
    @State var editingOrdered: Bool = false
    
    func move(from source: IndexSet, to destination: Int) {
        editingShows.move(fromOffsets: source, toOffset: destination)
    }
    
    var showSection: some View {
        
        VStack {
            let listObj = listVm.showListObj
            if (listObj != nil) {
                VStack {
                    // Listing the shows
                    
                }
            }
        }
    }
    
    var editRow: some View{
        // Control Group
        
        HStack {
            // List order
            let listObj = listVm.showListObj
            if (listObj!.ordered && !editing) {
                //
            }
            Spacer()
            // Ordered? buttons
            if (editing) {
                HStack {
                    Picker(selection: $editingOrdered, label: Text("List Ordered?")) {
                        Text("Unordered").tag(false)
                        Text("Ordered").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
            }
            Spacer()
            if (ownedList) {
                if (!editing) {
                    Button(action: {
                        editing = true
                        editingShows = listShows
                        editingOrdered = listObj!.ordered
                    }) {
                        Text("Edit List")
                    }
                    .buttonStyle(.bordered)
                } else {
                    HStack {
                        Button(action: {
                            editing = false
                            editingShows = listShows
                            editingOrdered = listObj!.ordered
                        }) {
                            Text("Cancel Edits")
                        }
                        .buttonStyle(.bordered)
                        Button(action: {
                            editing = false
                            // Update Firestore shows and ordered
                            if (editingShows != listShows) {
                                //updateListShows(listId: listObj!.id, showsAr: editingShows)
                                Task {
                                    await reloadData()
                                }
                            }
                            if (editingOrdered != listObj!.ordered) {
                                //updateListOrdered(listId: listObj!.id, listOrdered: editingOrdered)
                                Task {
                                    await reloadData()
                                }
                            }
                            
                        }) {
                            Text("Save Edits")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
    
    @State var addShowSearchText: String = ""
    var addShowSearchReturned: [Show] {
        return modelData.shows.filter { $0.name.localizedCaseInsensitiveContains(addShowSearchText) && !editingShows.contains($0) }
    }
    
    var showSearch: some View {
        VStack {
            Text("Search for a new show to add")
                .font(.title)
            Text("You can only add shows that you've added to your watchlist.")
            HStack { // Search Bar
                Image(systemName: "magnifyingglass")
                TextField("Search for a show", text: $addShowSearchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                if (!addShowSearchText.isEmpty) {
                    Button(action: {
                        addShowSearchText = ""
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            if (!addShowSearchText.isEmpty) {
                ForEach(addShowSearchReturned) { show in
                    HStack {
                        ListShowRow(show: show)
                        Spacer()
                        Button(action: {
                            editingShows.append(show)
                        }) {
                            Text("Add to list")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .padding(5)
        .background(.quaternary)
        .cornerRadius(5.0)
    }
     */
    
}
